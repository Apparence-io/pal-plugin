import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/hive_client.dart';
import 'package:pal/src/database/repository/client/page_user_visit_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/ui/client/helpers_synchronizer.dart';

//FIXME mock httpclient instead
class ClientSchemaRemoteRepositoryMock extends Mock implements ClientSchemaRemoteRepository {}

class PackageVersionReaderMock extends Mock implements PackageVersionReader {}

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  group('HelpersSynchronizer', () {

    HiveClient hiveClient = HiveClient(shouldInit: false)
      ..initLocal();

    HttpClient mockHttpClient = HttpClientMock();
    HelperGroupUserVisitRepository pageUserVisitLocalRepository = HelperGroupUserVisitLocalRepository(hiveBoxOpener: hiveClient.openVisitsBox);
    HelperGroupUserVisitRepository pageUserVisitRemoteRepository = HelperGroupUserVisitHttpRepository(httpClient: mockHttpClient);
    ClientSchemaLocalRepository schemaLocalRepository = ClientSchemaLocalRepository(hiveBoxOpener: hiveClient.openSchemaBox);
    ClientSchemaRemoteRepository schemaRemoteRepository = ClientSchemaRemoteRepositoryMock();
    String userId = "1221342";

    PackageVersionReader packageVersionReader = PackageVersionReaderMock();

    HelpersSynchronizer synchronizer = HelpersSynchronizer(
      pageUserVisitLocalRepository: pageUserVisitLocalRepository,
      pageUserVisitRemoteRepository: pageUserVisitRemoteRepository,
      schemaLocalRepository: schemaLocalRepository,
      schemaRemoteRepository: schemaRemoteRepository,
      packageVersionReader: packageVersionReader,
    );

    setUp(() async {
      await schemaLocalRepository.clear();
    });

    tearDown(() async {
      await schemaLocalRepository.clear();
      await pageUserVisitLocalRepository.clear();
      reset(packageVersionReader);
      reset(mockHttpClient);
    });

    SchemaEntity _mockSchema(int schemaVersion) {
      List<HelperEntity> remoteHelperList = [];
      for(var i = 0; i < 10; i++) {
        remoteHelperList.add(HelperEntity(id: i.toString()));
      }
      return SchemaEntity(
        projectId: "testprojectid",
        groups: [HelperGroupEntity(priority: 1, helpers: remoteHelperList)],
        schemaVersion: schemaVersion
      );
    }

    test('[sync] loads all helpers from server if has nothing in local database', () async {
      var currentSchema = _mockSchema(1);
      const appVersion = "1.0.0";
      when(() => schemaRemoteRepository.get(appVersion: appVersion))
        .thenAnswer((_) => Future.value(currentSchema));
      when(() => packageVersionReader.version).thenReturn(appVersion);
      when(() => mockHttpClient.get(Uri.parse('pal-analytic/users/$userId/groups')))
        .thenAnswer((_) => Future.value(Response('[]', 200)));

      expect(await schemaLocalRepository.get(appVersion: appVersion), isNull);
      await synchronizer.sync(userId);
      verify(() => schemaRemoteRepository.get(appVersion: appVersion)).called(1);
      var localSchema = await schemaLocalRepository.get(appVersion: appVersion);
      expect(localSchema, isNotNull);
      expect(localSchema, equals(currentSchema));
    });

    test('[sync] loads all helpers from server if local versions is lower than remote', () async {
      var currentSchema = _mockSchema(1);
      var lastRemoteSchema = _mockSchema(2);
      const appVersion = "1.0.0";
      when(() => packageVersionReader.version).thenReturn(appVersion);
      when(() => schemaRemoteRepository.get(appVersion: appVersion))
        .thenAnswer((_) => Future.value(currentSchema));
      when(() => schemaRemoteRepository.get(schemaVersion: 1, appVersion: appVersion))
        .thenAnswer((_) => Future.value(lastRemoteSchema));
      when(() => mockHttpClient.get(Uri.parse('pal-analytic/users/$userId/groups')))
        .thenAnswer((_) => Future.value(Response('[]', 200)));
      //first sync on null version
      await synchronizer.sync(userId);
      var localSchema = await schemaLocalRepository.get();
      expect(localSchema, equals(currentSchema));
      //second sync should send version 1 and get a new version
      await synchronizer.sync(userId);
      localSchema = await schemaLocalRepository.get();
      expect(localSchema!.schemaVersion, equals(lastRemoteSchema.schemaVersion));
      expect(localSchema, equals(lastRemoteSchema));
    });

    test('[sync] loads all helpers groups visits from server if has no schema in local database', () async {
      var currentSchema = _mockSchema(1);
      const appVersion = "1.0.0";
      var visitedUserGroupsJson = '''[
          {"pageId":"390289032", "helperGroupId": "AN1782187", "time": "2020-10-01T06:00:00Z", "version":"1.0.0"},
          {"pageId":"390289032", "helperGroupId": "AN1782186", "time": "2020-10-01T06:00:00Z", "version":"1.0.0"},
          {"pageId":"390289032", "helperGroupId": "AN1782185", "time": "2020-10-01T06:00:00Z", "version":"1.0.0"},
          {"pageId":"390289032", "helperGroupId": "AN1782184", "time": "2020-10-01T06:00:00Z", "version":"1.0.0"},
          {"pageId":"390289032", "helperGroupId": "AN1782183", "time": "2020-10-01T06:00:00Z", "version":"1.0.0"}
        ]''';
      when(() => schemaRemoteRepository.get(appVersion: appVersion))
        .thenAnswer((_) => Future.value(currentSchema));
      when(() => packageVersionReader.version).thenReturn(appVersion);
      when(() => mockHttpClient.get(Uri.parse('pal-analytic/users/$userId/groups')))
        .thenAnswer((_) => Future.value(Response(visitedUserGroupsJson, 200)));
      expect(await pageUserVisitLocalRepository.get(userId, appVersion), isEmpty);

      await synchronizer.sync(userId);
      verify(() => mockHttpClient.get(Uri.parse('pal-analytic/users/$userId/groups')))
        .called(1);
      var savedVisits = await pageUserVisitLocalRepository.get(userId, appVersion);
      expect(savedVisits, isNotEmpty);
      expect(savedVisits.length, equals(5));
    });

    test('[sync] do NOT load groups visits from server if has already sync a previous schema', () async {
      var currentSchema = _mockSchema(1);
      const appVersion = "1.0.0";
      var visitedUserGroupsJson = '''[]''';
      when(() => schemaRemoteRepository.get(appVersion: appVersion))
        .thenAnswer((_) => Future.value(currentSchema));
      when(() => packageVersionReader.version)
        .thenReturn(appVersion);
      when(() => mockHttpClient.get(Uri.parse('pal-analytic/users/$userId/groups')))
        .thenAnswer((_) => Future.value(Response(visitedUserGroupsJson, 200)));

      await synchronizer.sync(userId);
      when(() => schemaRemoteRepository.get(appVersion: appVersion))
        .thenAnswer((_) => Future.value(null));
      await synchronizer.sync(userId);
      // visits api is not called again because we gonne store them locally
      verify(() => mockHttpClient.get(Uri.parse('pal-analytic/users/$userId/groups')))
        .called(1);
    });

  });

}