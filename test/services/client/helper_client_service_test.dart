import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/database/hive_client.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/database/repository/in_app_user_repository.dart';
import 'package:pal/src/database/repository/page_repository.dart';
import 'package:pal/src/database/repository/version_repository.dart';
import 'package:pal/src/injectors/user_app/user_app_context.dart';
import 'package:pal/src/services/client/helper_client_service.dart';

class ClientHelperRepositoryMock extends Mock implements ClientHelperRepository {}

void main() {
  group('HelperClientService', () {

    HiveClient hiveClient = HiveClient()..init();

    HelperClientService helperClientService;
    ClientSchemaLocalRepository clientSchemaRepository = ClientSchemaLocalRepository(hiveBoxOpener: hiveClient.openSchemaBox);
    ClientHelperRepository clientHelperRepository = ClientHelperRepositoryMock();

    setUp(() async{
      helperClientService = HelperClientService.build(
        clientSchemaRepository: clientSchemaRepository,
        helperRemoteRepository: clientHelperRepository
      );
      var schema = SchemaEntity(
        projectId: "testprojectid",
        groups: [
          HelperGroupEntity(priority: 1, page: PageEntity(route: 'route1'), helpers: [HelperEntity(id: "1")]),
          HelperGroupEntity(priority: 2, page: PageEntity(route: 'route1'), helpers: [HelperEntity(id: "1")]),
          HelperGroupEntity(priority: 1, page: PageEntity(route: 'route2'), helpers: [HelperEntity(id: "1")]),
          HelperGroupEntity(priority: 2, page: PageEntity(route: 'route2'), helpers: [HelperEntity(id: "1")]),
          HelperGroupEntity(priority: 3, page: PageEntity(route: 'route2'), helpers: [HelperEntity(id: "1")]),
        ],
        schemaVersion: 1
      );
      await clientSchemaRepository.save(schema);
    });

    tearDown(() async {
      await clientSchemaRepository.clear();
    });

    test('getPageNextHelper(route, userId) returns the current page next helper group user has not seen', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('route1', '830298302d');
      expect(nextHelperGroup.priority, equals(2));
      expect(nextHelperGroup.page.route, equals('route1'));
    });

    test('getPageNextHelper(route, userId) on a non existing route should return null', () async {
      var nextHelperGroup = await helperClientService.getPageNextHelper('notExistingRoute', '830298302d');
      expect(nextHelperGroup, isNull);
    });

  });
}
