import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/database/entity/page_user_visit_entity.dart';
import 'package:pal/src/database/hive_client.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/page_user_visit_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/services/client/helper_client_service.dart';
import 'package:pal/src/services/client/versions/version.dart';
import 'package:pal/src/services/http_client/base_client.dart';
import 'package:pal/src/services/locale_service/locale_service.dart';

class HttpClientMock extends Mock implements HttpClient {}
class LocaleServiceMock extends Mock implements LocaleService {}

void main() {

  HiveClient hiveClient = HiveClient(shouldInit: false)
    ..initLocal();

  late HelperClientService helperClientService;
  HttpClient httpClientMock = HttpClientMock();
  LocaleService localeServiceMock = LocaleServiceMock();
  ClientSchemaLocalRepository clientSchemaRepository = ClientSchemaLocalRepository(hiveBoxOpener: hiveClient.openSchemaBox);
  ClientHelperRepository clientHelperRepository = ClientHelperRepository(httpClient: httpClientMock);
  HelperGroupUserVisitRepository remoteVisitRepository = HelperGroupUserVisitHttpRepository(httpClient: httpClientMock);
  HelperGroupUserVisitRepository localVisitRepository = HelperGroupUserVisitLocalRepository(hiveBoxOpener: hiveClient.openVisitsBox);
  const inAppUserId = "830298302d";

  group('[HelperClientService] getPageNextHelper', () {

    setUp(() async{
      helperClientService = HelperClientService.build(
        clientSchemaRepository: clientSchemaRepository,
        helperRemoteRepository: clientHelperRepository,
        localVisitRepository: localVisitRepository,
        remoteVisitRepository: remoteVisitRepository,
        userLocale: localeServiceMock
      );
      var schema = SchemaEntity(
        projectId: "testprojectid",
        groups: [
          // route 1
          HelperGroupEntity(id: "g1", triggerType: HelperTriggerType.ON_SCREEN_VISIT, priority: 1, 
            minVersion: "1.0.0", maxVersion: "2.0.0",
            page: PageEntity(id: 'p1', route: 'route1'), helpers: [HelperEntity(id: "1")]),
          HelperGroupEntity(id: "g2", triggerType: HelperTriggerType.ON_SCREEN_VISIT, priority: 2, 
            minVersion: "1.0.0", maxVersion: "2.0.0",
            page: PageEntity(id: 'p1', route: 'route1'), helpers: [HelperEntity(id: "2")]),
          // route 2
          HelperGroupEntity(id: "g3", triggerType: HelperTriggerType.ON_NEW_UPDATE, priority: 1, 
            minVersion: "1.0.0", maxVersion: "2.0.0",
            page: PageEntity(id: 'p2', route: 'route2'), helpers: [HelperEntity(id: "3")]),
          HelperGroupEntity(id: "g4", triggerType: HelperTriggerType.ON_SCREEN_VISIT, priority: 2, 
            minVersion: "1.0.0", maxVersion: "2.0.0",
            page: PageEntity(id: 'p2', route: 'route2'), helpers: [HelperEntity(id: "4")]),
          HelperGroupEntity(id: "g5", triggerType: HelperTriggerType.ON_NEW_UPDATE, priority: 3, 
            minVersion: "1.0.0", maxVersion: "2.0.0",
            page: PageEntity(id: 'p2', route: 'route2'), helpers: [HelperEntity(id: "5")]),
          // route 3
          HelperGroupEntity(id: "g6", triggerType: HelperTriggerType.ON_SCREEN_VISIT, priority: 1,
            minVersion: "1.0.0", maxVersion: "2.0.0", 
            page: PageEntity(id: 'p3', route: 'route3'), helpers: [HelperEntity(id: "3")]),
          HelperGroupEntity(id: "g7", triggerType: HelperTriggerType.ON_NEW_UPDATE, priority: 1, 
            minVersion: "1.0.0", maxVersion: "2.0.0",
            page: PageEntity(id: 'p3', route: 'route3'), helpers: [HelperEntity(id: "5")]),
          // route 4
          HelperGroupEntity(id: "g8", triggerType: HelperTriggerType.ON_NEW_UPDATE, priority: 1, 
            minVersion: "1.5.0", maxVersion: "2.0.0",
            page: PageEntity(id: 'p4', route: 'route4'), helpers: [HelperEntity(id: "5")]),
          // route 5
          HelperGroupEntity(id: "g9", triggerType: HelperTriggerType.ON_NEW_UPDATE, priority: 1, 
            minVersion: "0.1.0", maxVersion: "2.0.0",
            page: PageEntity(id: 'p5', route: 'route5'), helpers: [HelperEntity(id: "5")]),  
          // route 6
          HelperGroupEntity(id: "g10", triggerType: HelperTriggerType.ON_NEW_UPDATE, priority: 1, 
            minVersion: "0.1.0", maxVersion: null,
            page: PageEntity(id: 'p6', route: 'route6'), helpers: [HelperEntity(id: "5")]),    
        ],
        schemaVersion: 1
      );
      await clientSchemaRepository.save(schema);
      localVisitRepository.saveAll([
        HelperGroupUserVisitEntity(pageId: 'p1', helperGroupId: 'g2', visitDate: DateTime.now(), visitVersion: '0.1.0'), 
        HelperGroupUserVisitEntity(pageId: 'p3', helperGroupId: 'g6', visitDate: DateTime.now(), visitVersion: '1.0.0'),
      ]);
    });

    tearDown(() async {
      await clientSchemaRepository.clear();
      await localVisitRepository.clear();
    });

    test('current page = route1, user already see helper id = g2 => returns helper group id g1', () async {
      var nextHelperGroup = await (helperClientService.getPageNextHelper('route1', inAppUserId, AppVersion.fromString('1.0.1')));
      expect(nextHelperGroup!.priority, equals(1));
      expect(nextHelperGroup.id, equals("g1"));
      expect(nextHelperGroup.page!.route, equals('route1'));
    });

    test('current page = route2, user has not see anything => returns ON_SCREEN_VISIT type, group g4', () async {
      var nextHelperGroup = await (helperClientService.getPageNextHelper('route2', inAppUserId, AppVersion.fromString('1.0.1')));
      expect(nextHelperGroup!.id, equals("g4"));
      expect(nextHelperGroup.triggerType, equals(HelperTriggerType.ON_SCREEN_VISIT));
      expect(nextHelperGroup.page!.route, equals('route2'));
    });

    test('''current page = route3, user see all ON_SCREEN_VISIT, 
          first ON_NEW_UPDATE min version = 1.0.1
          user app version = 1.0.1 
         => returns ON_NEW_UPDATE type with lower prio, group g7''', () async {
      var nextHelperGroup = await (helperClientService.getPageNextHelper('route3', inAppUserId, AppVersion.fromString('1.0.1')));
      expect(nextHelperGroup!.id, equals("g7"));
      expect(nextHelperGroup.triggerType, equals(HelperTriggerType.ON_NEW_UPDATE));
      expect(nextHelperGroup.priority, equals(1));
      expect(nextHelperGroup.page!.route, equals('route3'));
    });

    test('''current page = route4, user see all ON_SCREEN_VISIT, 
          first ON_NEW_UPDATE min version = 1.0.1
          user app version = 1.0.0 
         => returns null, user app version is too low ''', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('route4', inAppUserId, AppVersion.fromString('1.0.0'));
      expect(nextHelperGroup, isNull);
    });

    test('''current page = route4, user see all ON_SCREEN_VISIT, 
          first ON_NEW_UPDATE min version = 1.0.1 and max version = 2.0.0
          user app version = 2.5.0 
         => returns null, user app version is too high ''', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('route4', inAppUserId, AppVersion.fromString('2.5.0'));
      expect(nextHelperGroup, isNull);
    });

    test('''current page = route5, user first visit version is 0.1.0, 
          first ON_NEW_UPDATE min version = 0.1.0
          user app version = 0.1.0
         => returns null, user is new do not show new update message ''', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('route5', inAppUserId, AppVersion.fromString('0.1.0'));
      expect(nextHelperGroup, isNull);
    });

    test('''current page = route6, 
          first ON_NEW_UPDATE id g10 min version = 0.1.0 max is null
          user app version = 0.5.0
         => returns group g10''', () async {
      var nextHelperGroup = await (helperClientService.getPageNextHelper('route6', inAppUserId, AppVersion.fromString('0.5.0')));
      expect(nextHelperGroup, isNotNull);
      expect(nextHelperGroup!.id, equals("g10"));
    });

    test('route not exists, return null', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('notExistingRoute', inAppUserId, AppVersion.fromString('1.0.1'));
      expect(nextHelperGroup, isNull);
    });

  });

  group('[HelperClientService] onHelperTrigger', () {

    setUp(() async{
      helperClientService = HelperClientService.build(
        clientSchemaRepository: clientSchemaRepository,
        helperRemoteRepository: clientHelperRepository,
        localVisitRepository: localVisitRepository,
        remoteVisitRepository: remoteVisitRepository,
        userLocale: LocaleService(defaultLocale: Locale('en'))
      );
      var schema = SchemaEntity(
        projectId: "testprojectid",
        groups: [
          HelperGroupEntity(id: "g1", priority: 1, page: PageEntity(id: 'p1', route: 'route1'), helpers: [HelperEntity(id: "1")]),
          HelperGroupEntity(id: "g2", priority: 2, page: PageEntity(id: 'p1', route: 'route1'), helpers: [HelperEntity(id: "2")]),
          HelperGroupEntity(id: "g3", priority: 1, page: PageEntity(id: 'p2', route: 'route2'), helpers: [HelperEntity(id: "3")]),
          HelperGroupEntity(id: "g4", priority: 2, page: PageEntity(id: 'p2', route: 'route2'), helpers: [HelperEntity(id: "4")]),
          HelperGroupEntity(id: "g5", priority: 3, page: PageEntity(id: 'p2', route: 'route2'), helpers: [HelperEntity(id: "5")]),
        ],
        schemaVersion: 1
      );
      await clientSchemaRepository.save(schema);
      localVisitRepository.saveAll([
        HelperGroupUserVisitEntity(pageId: 'p1', helperGroupId: 'g2', visitDate: DateTime.now(), visitVersion: '0.1.0')
      ]);
    });

    tearDown(() async {
      await clientSchemaRepository.clear();
      await localVisitRepository.clear();
    });

    test('save visit on remote server, save visit locally', () async {
      var pageId = 'p1';
      var helperGroup = HelperGroupEntity(id: "g1", priority: 1, page: PageEntity(id: 'p1', route: 'route1'), helpers: [HelperEntity(id: "1")]);
      var helperGroupId = helperGroup.id;
      var url = 'pal-analytic/users/$inAppUserId/groups/$helperGroupId/helpers/${helperGroup.helpers![0].id}';
      var expectedBody = jsonEncode({ 
        'answer': true,
        'isLast': true,
        'language': 'en'
      });
      when(() => httpClientMock.post(Uri.parse(url),
        body: expectedBody,
        headers: {"inAppUserId": inAppUserId})
      ).thenAnswer((_) => Future.value(Response('', 200)));
      var visitsBefore = await localVisitRepository.get(inAppUserId, null);
      expect(visitsBefore.length, equals(1));

      await helperClientService.onHelperTrigger(pageId, helperGroup, helperGroup.helpers![0], inAppUserId, true, '1.0.0');
      verify(() => httpClientMock.post(Uri.parse(url),
        body: expectedBody,
        headers: {"inAppUserId": inAppUserId})
      ).called(1);
      var visits = await localVisitRepository.get(inAppUserId, null);
      expect(visits.length, equals(2));
      expect(visits.last.visitDate, isNotNull);
      expect(visits.last.visitVersion, equals('1.0.0'));
    });

    test('save visit on remote server fails, save visit locally should not be called', () async{
      var pageId = 'p1';
      var helperGroup = HelperGroupEntity(id: "g1", priority: 1, page: PageEntity(id: 'p1', route: 'route1'), helpers: [HelperEntity(id: "1")]);
      var helperGroupId = helperGroup.id;
      var url = 'pal-analytic/users/$inAppUserId/groups/$helperGroupId/helpers/${helperGroup.helpers![0].id}';
      var expectedBody = jsonEncode({ 
        'answer': true,
        'isLast': true,
        'language': 'en'
      });
      when(() => httpClientMock.post(Uri.parse(url),
        body: expectedBody,
        headers: {"inAppUserId": inAppUserId})
      ).thenThrow((_) => throw "ERROR");

      await helperClientService.onHelperTrigger(pageId, helperGroup, helperGroup.helpers![0], inAppUserId, true, '1.0.0');
      verify(() => httpClientMock.post(Uri.parse(url),
        body: expectedBody,
        headers: {"inAppUserId": inAppUserId})
      ).called(1);
      var visits = await localVisitRepository.get(inAppUserId, null);
      expect(visits.length, equals(1));
    });

  });
}
