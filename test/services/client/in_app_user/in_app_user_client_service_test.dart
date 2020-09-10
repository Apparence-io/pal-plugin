import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/database/entity/in_app_user_entity.dart';
import 'package:palplugin/src/database/repository/in_app_user_repository.dart';
import 'package:palplugin/src/services/client/in_app_user/in_app_user_client_service.dart';
import 'package:palplugin/src/services/client/in_app_user/in_app_user_client_storage.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

class _HttpClientMock extends Mock implements HttpClient{}

class _InAppUserStorageClientManagerMock extends Mock implements InAppUserStorageClientManager{}

void main() {
  group('Test in app user service', () {



    test('Test get and create in app user => in app user already created', () async {

      final HttpClient httpClient = _HttpClientMock();

      final InAppUserStorageClientManager mockedInAppUserStorageClientManager = _InAppUserStorageClientManagerMock();
      when(mockedInAppUserStorageClientManager.readInAppUser()).thenAnswer((_) => Future.value(InAppUserEntity(
        id: "db6b01e1-b649-4a17-949a-9ab320601001",
        inAppId: "test",
        disabledHelpers: false,
        anonymous: false,
      )));

      final InAppUserRepository inAppUserRepository = InAppUserRepository(httpClient: httpClient);
      final InAppUserClientService inAppUserClientService = InAppUserClientService.build(inAppUserRepository, inAppUserStorageClientManager: mockedInAppUserStorageClientManager);
      final InAppUserEntity inAppUserEntity = await inAppUserClientService.getOrCreate();
      assert(inAppUserEntity.id == "db6b01e1-b649-4a17-949a-9ab320601001");
      assert(inAppUserEntity.inAppId == "test");
      assert(inAppUserEntity.disabledHelpers == false);
      assert(inAppUserEntity.anonymous == false);
    });

    test('Test get and create in app user => in app user doesn\'t exists', () async {

      final HttpClient httpClient = _HttpClientMock();
      final String content = new File("test/services/client/in_app_user/resources/in_app_user_anonymous.json").readAsStringSync();
      final String expectedBody = new File("test/services/client/in_app_user/resources/in_app_user_create_body.json").readAsStringSync();
      when(httpClient.post("client/in-app-users", body: expectedBody)).thenAnswer((_) => Future.value(Response(content, 200)));

      final InAppUserStorageClientManager mockedInAppUserStorageClientManager = _InAppUserStorageClientManagerMock();
      when(mockedInAppUserStorageClientManager.readInAppUser()).thenAnswer((_) => Future.value(null));

      final InAppUserRepository inAppUserRepository = InAppUserRepository(httpClient: httpClient);
      final InAppUserClientService inAppUserClientService = InAppUserClientService.build(inAppUserRepository, inAppUserStorageClientManager: mockedInAppUserStorageClientManager);
      final InAppUserEntity inAppUserEntity = await inAppUserClientService.getOrCreate();
      assert(inAppUserEntity.id == "db6b01e1-b649-4a17-949a-9ab320601001");
      assert(inAppUserEntity.inAppId == null);
      assert(inAppUserEntity.disabledHelpers == false);
      assert(inAppUserEntity.anonymous == true);

    });

    test('Test on connect => not anonymous', () async {

      final HttpClient httpClient = _HttpClientMock();

      final InAppUserStorageClientManager mockedInAppUserStorageClientManager = _InAppUserStorageClientManagerMock();
      when(mockedInAppUserStorageClientManager.readInAppUser()).thenAnswer((_) => Future.value(InAppUserEntity(
        id: "db6b01e1-b649-4a17-949a-9ab320601001",
        inAppId: "test",
        disabledHelpers: false,
        anonymous: false,
      )));

      final InAppUserRepository inAppUserRepository = InAppUserRepository(httpClient: httpClient);
      final InAppUserClientService inAppUserClientService = InAppUserClientService.build(inAppUserRepository, inAppUserStorageClientManager: mockedInAppUserStorageClientManager);
      final InAppUserEntity inAppUserEntity = await inAppUserClientService.onConnect("test");
      assert(inAppUserEntity.id == "db6b01e1-b649-4a17-949a-9ab320601001");
      assert(inAppUserEntity.inAppId == "test");
      assert(inAppUserEntity.disabledHelpers == false);
      assert(inAppUserEntity.anonymous == false);
    });

    test('Test on connect => anonymous', () async {

      final HttpClient httpClient = _HttpClientMock();
      final String content = new File("test/services/client/in_app_user/resources/in_app_user.json").readAsStringSync();
      final String expectedBody = new File("test/services/client/in_app_user/resources/in_app_user_on_connect_body.json").readAsStringSync();
      when(httpClient.put("client/in-app-users/db6b01e1-b649-4a17-949a-9ab320601001", body: expectedBody)).thenAnswer((_) => Future.value(Response(content, 200)));


      final InAppUserStorageClientManager mockedInAppUserStorageClientManager = _InAppUserStorageClientManagerMock();
      when(mockedInAppUserStorageClientManager.readInAppUser()).thenAnswer((_) {
        return Future.value(InAppUserEntity(
          id: "db6b01e1-b649-4a17-949a-9ab320601001",
          inAppId: null,
          disabledHelpers: false,
          anonymous: true,
        ));
      });

      final InAppUserRepository inAppUserRepository = InAppUserRepository(httpClient: httpClient);
      final InAppUserClientService inAppUserClientService = InAppUserClientService.build(inAppUserRepository, inAppUserStorageClientManager: mockedInAppUserStorageClientManager);
      final InAppUserEntity inAppUserEntity = await inAppUserClientService.onConnect("test");
      assert(inAppUserEntity.id == "db6b01e1-b649-4a17-949a-9ab320601001");
      assert(inAppUserEntity.inAppId == "test");
      assert(inAppUserEntity.disabledHelpers == false);
      assert(inAppUserEntity.anonymous == false);
    });


    test('Test update => user not saved', () async {

      final HttpClient httpClient = _HttpClientMock();

      final InAppUserStorageClientManager mockedInAppUserStorageClientManager = _InAppUserStorageClientManagerMock();
      when(mockedInAppUserStorageClientManager.readInAppUser()).thenAnswer((_) => Future.value(null));

      final InAppUserRepository inAppUserRepository = InAppUserRepository(httpClient: httpClient);
      final InAppUserClientService inAppUserClientService = InAppUserClientService.build(inAppUserRepository, inAppUserStorageClientManager: mockedInAppUserStorageClientManager);
      final InAppUserEntity inAppUserEntity = await inAppUserClientService.update(true);
      assert(inAppUserEntity == null);
    });

    test('Test update => user saved', () async {

      final HttpClient httpClient = _HttpClientMock();
      final String content = new File("test/services/client/in_app_user/resources/in_app_user.json").readAsStringSync();
      final String expectedBody = new File("test/services/client/in_app_user/resources/in_app_user_update_body.json").readAsStringSync();
      when(httpClient.put("client/in-app-users/db6b01e1-b649-4a17-949a-9ab320601001", body: expectedBody)).thenAnswer((_) => Future.value(Response(content, 200)));


      final InAppUserStorageClientManager mockedInAppUserStorageClientManager = _InAppUserStorageClientManagerMock();
      when(mockedInAppUserStorageClientManager.readInAppUser()).thenAnswer((_) {
        return Future.value(InAppUserEntity(
          id: "db6b01e1-b649-4a17-949a-9ab320601001",
          inAppId: null,
          disabledHelpers: false,
          anonymous: true,
        ));
      });

      final InAppUserRepository inAppUserRepository = InAppUserRepository(httpClient: httpClient);
      final InAppUserClientService inAppUserClientService = InAppUserClientService.build(inAppUserRepository, inAppUserStorageClientManager: mockedInAppUserStorageClientManager);
      final InAppUserEntity inAppUserEntity = await inAppUserClientService.update(false);
      assert(inAppUserEntity.id == "db6b01e1-b649-4a17-949a-9ab320601001");
      assert(inAppUserEntity.inAppId == "test");
      assert(inAppUserEntity.disabledHelpers == false);
      assert(inAppUserEntity.anonymous == false);
    });

    test('Test disconnected => not anonymous user', () async {

      final HttpClient httpClient = _HttpClientMock();
      final String content = new File("test/services/client/in_app_user/resources/in_app_user_anonymous.json").readAsStringSync();
      final String expectedBody = new File("test/services/client/in_app_user/resources/in_app_user_create_body.json").readAsStringSync();
      when(httpClient.post("client/in-app-users", body: expectedBody)).thenAnswer((_) => Future.value(Response(content, 200)));


      final InAppUserStorageClientManager mockedInAppUserStorageClientManager = _InAppUserStorageClientManagerMock();
      when(mockedInAppUserStorageClientManager.readInAppUser()).thenAnswer((_) {
        return Future.value(InAppUserEntity(
          id: "db6b01e1-b649-4a17-949a-9ab320601001",
          inAppId: 'test',
          disabledHelpers: false,
          anonymous: false,
        ));
      });

      final InAppUserRepository inAppUserRepository = InAppUserRepository(httpClient: httpClient);
      final InAppUserClientService inAppUserClientService = InAppUserClientService.build(inAppUserRepository, inAppUserStorageClientManager: mockedInAppUserStorageClientManager);
      final InAppUserEntity inAppUserEntity = await inAppUserClientService.onDisconnect();
      assert(inAppUserEntity.id == "db6b01e1-b649-4a17-949a-9ab320601001");
      assert(inAppUserEntity.inAppId == null);
      assert(inAppUserEntity.disabledHelpers == false);
      assert(inAppUserEntity.anonymous == true);
    });

    test('Test disconnected => anonymous user', () async {

      final HttpClient httpClient = _HttpClientMock();

      final InAppUserStorageClientManager mockedInAppUserStorageClientManager = _InAppUserStorageClientManagerMock();
      when(mockedInAppUserStorageClientManager.readInAppUser()).thenAnswer((_) {
        return Future.value(InAppUserEntity(
          id: "db6b01e1-b649-4a17-949a-9ab320601001",
          inAppId: 'test',
          disabledHelpers: false,
          anonymous: true,
        ));
      });

      final InAppUserRepository inAppUserRepository = InAppUserRepository(httpClient: httpClient);
      final InAppUserClientService inAppUserClientService = InAppUserClientService.build(inAppUserRepository, inAppUserStorageClientManager: mockedInAppUserStorageClientManager);
      final InAppUserEntity inAppUserEntity = await inAppUserClientService.onDisconnect();
      assert(inAppUserEntity.id == "db6b01e1-b649-4a17-949a-9ab320601001");
      assert(inAppUserEntity.inAppId == "test");
      assert(inAppUserEntity.disabledHelpers == false);
      assert(inAppUserEntity.anonymous == true);
    });
  });
}
