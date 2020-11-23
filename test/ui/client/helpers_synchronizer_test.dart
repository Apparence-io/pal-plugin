import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/ui/client/helpers_synchronizer.dart';

//FIXME mock httpclient instead
class ClientSchemaRemoteRepositoryMock extends Mock implements ClientSchemaRemoteRepository {}
class PackageVersionReaderMock extends Mock implements PackageVersionReader {}

void main() {
  group('HelpersSynchronizer', () {

    ClientSchemaRemoteRepository remoteRepository = ClientSchemaRemoteRepositoryMock();
    ClientSchemaLocalRepository localRepository = ClientSchemaLocalRepository();
    PackageVersionReader packageVersionReader = PackageVersionReaderMock();
    
    HelpersSynchronizer synchronizer = HelpersSynchronizer(
      remoteRepository: remoteRepository,
      localRepository: localRepository,
      packageVersionReader: packageVersionReader
    );

    setUp(() async {
      await localRepository.clear();
    });

    tearDown(() async {
      await localRepository.clear();
      reset(packageVersionReader);
    });

    SchemaEntity _mockSchema(int schemaVersion) {
      List<HelperEntity> remoteHelperList = new List();
      for(var i = 0; i < 10; i++) {
        remoteHelperList.add(HelperEntity(id: i.toString()));
      }
      return SchemaEntity(
        projectId: "testprojectid",
        groups: [HelperGroupEntity(priority: 1, helpers: remoteHelperList)],
        schemaVersion: schemaVersion
      );
    }

    test('sync loads all helpers from server if has nothing in local database', () async {
      var currentSchema = _mockSchema(1);
      const appVersion = "1.0.0";
      when(remoteRepository.get(appVersion: appVersion)).thenAnswer((_) => Future.value(currentSchema));
      when(packageVersionReader.version).thenReturn(appVersion);

      expect(await localRepository.get(appVersion: appVersion), isNull);
      await synchronizer.sync();
      verify(remoteRepository.get(appVersion: appVersion)).called(1);
      var localSchema = await localRepository.get(appVersion: appVersion);
      expect(localSchema, isNotNull);
      expect(localSchema, equals(currentSchema));
    });

    test('sync loads all helpers from server if local versions is lower than remote', () async {
      var currentSchema = _mockSchema(1);
      var lastRemoteSchema = _mockSchema(2);
      const appVersion = "1.0.0";
      when(packageVersionReader.version).thenReturn(appVersion);
      when(remoteRepository.get(appVersion: appVersion)).thenAnswer((_) => Future.value(currentSchema));
      when(remoteRepository.get(schemaVersion: 1, appVersion: appVersion)).thenAnswer((_) => Future.value(lastRemoteSchema));
      //first sync on null version
      await synchronizer.sync();
      var localSchema = await localRepository.get();
      expect(localSchema, equals(currentSchema));
      //second sync should send version 1 and get a new version
      await synchronizer.sync();
      localSchema = await localRepository.get();
      expect(localSchema.schemaVersion, equals(lastRemoteSchema.schemaVersion));
      expect(localSchema, equals(lastRemoteSchema));
    });

  });

}