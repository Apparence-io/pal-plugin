import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
import 'package:pal/src/services/http_client/base_client.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {

  HiveClient hiveClient = HiveClient(shouldInit: false)
    ..initLocal();

  HelperClientService helperClientService;
  HttpClient httpClientMock = HttpClientMock();
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
        remoteVisitRepository: remoteVisitRepository
      );
      var schema = SchemaEntity(
        projectId: "testprojectid",
        groups: [
          HelperGroupEntity(id: "g1", type: HelperTriggerType.ON_SCREEN_VISIT, priority: 1, page: PageEntity(id: 'p1', route: 'route1'), helpers: [HelperEntity(id: "1")]),
          HelperGroupEntity(id: "g2", type: HelperTriggerType.ON_SCREEN_VISIT, priority: 2, page: PageEntity(id: 'p1', route: 'route1'), helpers: [HelperEntity(id: "2")]),
          HelperGroupEntity(id: "g3", type: HelperTriggerType.ON_NEW_UPDATE, priority: 1, page: PageEntity(id: 'p2', route: 'route2'), helpers: [HelperEntity(id: "3")]),
          HelperGroupEntity(id: "g4", type: HelperTriggerType.ON_SCREEN_VISIT, priority: 2, page: PageEntity(id: 'p2', route: 'route2'), helpers: [HelperEntity(id: "4")]),
          HelperGroupEntity(id: "g5", type: HelperTriggerType.ON_NEW_UPDATE, priority: 3, page: PageEntity(id: 'p2', route: 'route2'), helpers: [HelperEntity(id: "5")]),
          HelperGroupEntity(id: "g6", type: HelperTriggerType.ON_SCREEN_VISIT, priority: 1, page: PageEntity(id: 'p3', route: 'route3'), helpers: [HelperEntity(id: "3")]),
          HelperGroupEntity(id: "g7", type: HelperTriggerType.ON_NEW_UPDATE, priority: 1, page: PageEntity(id: 'p3', route: 'route3'), helpers: [HelperEntity(id: "5")]),
        ],
        schemaVersion: 1
      );
      await clientSchemaRepository.save(schema);
      localVisitRepository.saveAll([
        HelperGroupUserVisitEntity(pageId: 'p1', helperGroupId: 'g2'),
        HelperGroupUserVisitEntity(pageId: 'p3', helperGroupId: 'g6'),
      ]);
    });

    tearDown(() async {
      await clientSchemaRepository.clear();
      await localVisitRepository.clear();
    });

    test('current page = route1, user already see helper id = g2 => returns helper group id g1', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('route1', inAppUserId);
      expect(nextHelperGroup.priority, equals(1));
      expect(nextHelperGroup.id, equals("g1"));
      expect(nextHelperGroup.page.route, equals('route1'));
    });

    test('current page = route2, user has not see anything => returns ON_SCREEN_VISIT type, group g4', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('route2', inAppUserId);
      expect(nextHelperGroup.id, equals("g4"));
      expect(nextHelperGroup.type, equals(HelperTriggerType.ON_SCREEN_VISIT));
      expect(nextHelperGroup.page.route, equals('route2'));
    });

    test('current page = route3, user see all ON_SCREEN_VISIT => returns ON_NEW_UPDATE type with lower prio, group g7', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('route3', inAppUserId);
      expect(nextHelperGroup.id, equals("g7"));
      expect(nextHelperGroup.type, equals(HelperTriggerType.ON_NEW_UPDATE));
      expect(nextHelperGroup.priority, equals(1));
      expect(nextHelperGroup.page.route, equals('route3'));
    });

    test('route not exists, return null', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('notExistingRoute', inAppUserId);
      expect(nextHelperGroup, isNull);
    });

  });

  group('[HelperClientService] onHelperTrigger', () {

    setUp(() async{
      helperClientService = HelperClientService.build(
        clientSchemaRepository: clientSchemaRepository,
        helperRemoteRepository: clientHelperRepository,
        localVisitRepository: localVisitRepository,
        remoteVisitRepository: remoteVisitRepository
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
        HelperGroupUserVisitEntity(pageId: 'p1', helperGroupId: 'g2')
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
      when(httpClientMock.put('pal-business/client/group/$helperGroupId/triggered',
        body: jsonEncode({ 'positiveFeedback': true }),
        headers: {"inAppUserId": inAppUserId})
      ).thenAnswer((_) => Future.value());

      await helperClientService.onHelperTrigger(pageId, helperGroup, helperGroup.helpers[0], inAppUserId, true);
      verify(httpClientMock.put('pal-business/client/group/$helperGroupId/triggered',
        body: jsonEncode({ 'positiveFeedback': true }),
        headers: {"inAppUserId": inAppUserId})
      ).called(1);
      var visits = await localVisitRepository.get(inAppUserId, null);
      expect(visits.length, equals(2));
    });

    test('save visit on remote server fails, save visit locally should not be called', () async{
      var pageId = 'p1';
      var helperGroup = HelperGroupEntity(id: "g1", priority: 1, page: PageEntity(id: 'p1', route: 'route1'), helpers: [HelperEntity(id: "1")]);
      var helperGroupId = helperGroup.id;
      when(httpClientMock.put('pal-business/client/group/$helperGroupId/triggered',
        body: jsonEncode({ 'positiveFeedback': true }),
        headers: {"inAppUserId": inAppUserId})
      ).thenThrow((_) => throw "ERROR");

      await helperClientService.onHelperTrigger(pageId, helperGroup, helperGroup.helpers[0], inAppUserId, true);
      verify(httpClientMock.put('pal-business/client/group/$helperGroupId/triggered',
        body: jsonEncode({ 'positiveFeedback': true }),
        headers: {"inAppUserId": inAppUserId})
      ).called(1);
      var visits = await localVisitRepository.get(inAppUserId, null);
      expect(visits.length, equals(1));
    });

  });
}
