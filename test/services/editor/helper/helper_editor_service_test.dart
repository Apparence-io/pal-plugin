import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/database/adapter/helper_entity_adapter.dart' as EntityAdapter;
import 'package:pal/src/database/adapter/page_entity_adapter.dart' as PageEntityAdapter;
import 'package:pal/src/database/adapter/version_entity_adapter.dart' as VersionEntityAdapter;
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/database/entity/version_entity.dart';
import 'package:pal/src/database/repository/editor/helper_editor_repository.dart';
import 'package:pal/src/database/repository/editor/helper_group_repository.dart';
import 'package:pal/src/database/repository/page_repository.dart';
import 'package:pal/src/database/repository/version_repository.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/http_client/base_client.dart';

import 'anchored_model_data.dart';
import 'fullscreen_model_data.dart';
import 'simple_model_data.dart';
import 'update_model_data.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {

  HttpClientMock httpClientMock = HttpClientMock();

  EditorHelperService editorHelperService = EditorHelperService.fromDependencies(
    EditorHelperRepository(httpClient: httpClientMock),
    VersionHttpRepository(httpClient: httpClientMock),
    PageRepository(httpClient: httpClientMock),
    EditorHelperGroupRepository(httpClient: httpClientMock)
  );

  _testCreateHelper(dynamic args, HelperEntity expectedHelperResult, Function creationCall) async {
    assert(args.helperGroup.id != null, "a group id must be provided");
    // mock get page request
    PageEntity existingPage = PageEntity(id: "IUEZOUEA", creationDate: DateTime.now(), lastUpdateDate: DateTime.now(), route: args.config.route);
    var pageResJson = PageEntityAdapter.PageEntityAdapter().toJson(existingPage);
    var pageablePageResJson = '{"content":[$pageResJson], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    //var pageReqJson = jsonEncode({'name': args.config.route});
    when(httpClientMock.get('pal-business/editor/pages?route=${args.config.route}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(pageablePageResJson, 200)));
    // mock save helper
    var expectedHelperResultJson = EntityAdapter.HelperEntityAdapter().toJson(expectedHelperResult..id = null);
    when(httpClientMock.post('pal-business/editor/groups/${args.helperGroup.id}/helpers', body: anyNamed("body")))
      .thenAnswer((_) => Future.value(Response(expectedHelperResultJson, 200)));
    await creationCall();
    // group exists here and should not been called
    verifyNever(httpClientMock.post('pal-business/editor/pages/${existingPage.id}/groups', body: captureAnyNamed("body")));
    var capturedCall = verify(
        httpClientMock.post('pal-business/editor/groups/${args.helperGroup.id}/helpers',
        body: captureAnyNamed("body"))
    ).captured;
    expect(capturedCall[0], equals(expectedHelperResultJson));
  }

  _testCreateHelperWithGroupAndVersionAndPage(dynamic args, HelperEntity expectedHelperRequest, Function creationCall) async {
    assert(args.helperGroup.id == null, "no group id must be provided ${args.helperGroup.id}");
    assert(args.helperGroup.name != null, "a group name must be provided");
    // mock get page request then create page
    PageEntity existingPage = PageEntity(id: "IUEZOUEA", creationDate: DateTime.now(), lastUpdateDate: DateTime.now(), route: args.config.route);
    var pageResJson = PageEntityAdapter.PageEntityAdapter().toJson(existingPage);
    var pageablePageResJson = '{"content":[], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    var pageCreationReqJson = jsonEncode({'route': args.config.route});
    when(httpClientMock.get('pal-business/editor/pages?route=${args.config.route}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(pageablePageResJson, 200)));
    when(httpClientMock.post('pal-business/editor/pages', body: pageCreationReqJson)).thenAnswer((_) => Future.value(Response(pageResJson, 200)));
    // mock create group
    var groupCreationReqJson = '{"name":"${args.helperGroup.name}","triggerType":null,"versionMinId":25,"versionMaxId":null}';
    var groupCreationResJson = '{"id":"89032803JS", "name":"${args.helperGroup.name}", "minVersionId": 25, "maxVersionId": null}';
    when(httpClientMock.post('pal-business/editor/pages/${existingPage.id}/groups', body: anyNamed('body')))
      .thenAnswer((_) => Future.value(Response(groupCreationResJson, 200)));
    // mock get min version request then create
    VersionEntity versionEntity = VersionEntity(id: 25, name: args.helperGroup.minVersion);
    var versionReqJson = VersionEntityAdapter.VersionEntityAdapter().toJson(versionEntity);
    var versionMinCreationReqJson = jsonEncode({'name': args.helperGroup.minVersion});
    var versionPageJson = '{"content":[], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    when(httpClientMock.get('pal-business/editor/versions?versionName=${args.helperGroup.minVersion}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(versionPageJson, 200)));
    when(httpClientMock.post('pal-business/editor/versions', body: versionMinCreationReqJson)).thenAnswer((_) => Future.value(Response(versionReqJson, 200)));
    // mock save helper
    var expectedHelperResultJson = EntityAdapter.HelperEntityAdapter().toJson(expectedHelperRequest);
    when(httpClientMock.post('pal-business/editor/groups/89032803JS/helpers', body: anyNamed("body")))
      .thenAnswer((_) => Future.value(Response(expectedHelperResultJson, 200)));
    await creationCall();
    verify(httpClientMock.get('pal-business/editor/pages?route=${args.config.route}&pageSize=1')).called(1);
    verify(httpClientMock.post('pal-business/editor/pages', body: pageCreationReqJson)).called(1);
    verify(httpClientMock.get('pal-business/editor/versions?versionName=${args.helperGroup.minVersion}&pageSize=1')).called(1);
    verify(httpClientMock.post('pal-business/editor/versions', body: versionMinCreationReqJson)).called(1);
    var capturedGroupCreationCall =  verify(httpClientMock.post('pal-business/editor/pages/${existingPage.id}/groups', body: captureAnyNamed("body"))).captured;
    expect(capturedGroupCreationCall[0], equals(groupCreationReqJson));
    var capturedHelperCreationCall =  verify(httpClientMock.post('pal-business/editor/groups/89032803JS/helpers', body: captureAnyNamed("body"))).captured;
    expect(capturedHelperCreationCall[0], equals(expectedHelperResultJson));
  }

  _testUpdateHelper(dynamic args, HelperEntity expectedHelperResult, Function updateCall) async {
    assert(args.helperGroup.id != null, "a group id must be provided");
    // mock get page request
    PageEntity existingPage = PageEntity(id: "IUEZOUEA", creationDate: DateTime.now(), lastUpdateDate: DateTime.now(), route: args.config.route);
    var pageResJson = PageEntityAdapter.PageEntityAdapter().toJson(existingPage);
    var pageablePageResJson = '{"content":[$pageResJson], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    //var pageReqJson = jsonEncode({'name': args.config.route});
    when(httpClientMock.get('pal-business/editor/pages?route=${args.config.route}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(pageablePageResJson, 200)));
    // mock get min version request
    VersionEntity versionEntity = VersionEntity(id: 25, name: args.helperGroup.minVersion);
    var versionReqJson = VersionEntityAdapter.VersionEntityAdapter().toJson(versionEntity);
    var versionPageJson = '{"content":[$versionReqJson], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    when(httpClientMock.get('pal-business/editor/versions?versionName=${args.helperGroup.minVersion}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(versionPageJson, 200)));
    // mock save helper
    var expectedHelperResultJson = EntityAdapter.HelperEntityAdapter().toJson(expectedHelperResult..id = "JDLSKJDSD");
    args.config.id = expectedHelperResult.id;
    when(httpClientMock.put('pal-business/editor/helpers/${args.config.id}', body: anyNamed("body")))
      .thenAnswer((_) => Future.value(Response(expectedHelperResultJson, 200)));
    await updateCall();
    // group exists here and should not been called
    var capturedHelperCreation = verify(httpClientMock.put(
      'pal-business/editor/helpers/${args.config.id}',
      body: captureAnyNamed("body"))
    ).captured;
    expect(capturedHelperCreation[0], expectedHelperResultJson);
    verifyNever(httpClientMock.post('pal-business/editor/pages/${existingPage.id}/groups', body: captureAnyNamed("body")));
  }

  group('[EditorHelperService] - save simpleHelper', () {

    setUp(() => reset(httpClientMock));

    test('page = "route", version = "1.0.1", group exists, helper not exists => page exists, version exists, groups exists, new helper created', () async {
      var args = genSimpleHelperData();
      HelperEntity expectedHelperResult = genExpectedSimpleEntity(args);
      await _testCreateHelper(args, expectedHelperResult, () => editorHelperService.saveSimpleHelper(args));
    });

    test('page = "route", version min and max = "1.0.1", group not exists, version min/max not exists, helper not exists => group is created, page is created, versions are created, new helper created', () async {
      var argsWithNewGroup = genSimpleHelperData(
        groupConfig: HelperGroupConfig(
          name: "my helper group 01",
          minVersion: "1.0.0",
          maxVersion: null)
      );
      HelperEntity expectedHelperResult = genExpectedSimpleEntity(argsWithNewGroup);
      await _testCreateHelperWithGroupAndVersionAndPage(argsWithNewGroup, expectedHelperResult, () => editorHelperService.saveSimpleHelper(argsWithNewGroup));
    });

    test('page = "route", version = "1.0.1", group exists, helper exists => helper updated', () async {
      var args = genSimpleHelperData();
      HelperEntity expectedHelperResult = genExpectedSimpleEntity(args);
      await _testUpdateHelper(args, expectedHelperResult, () => editorHelperService.saveSimpleHelper(args));
    });

  });

  group('[EditorHelperService] - save fullScreenHelper', () {

    setUp(() => reset(httpClientMock));

    test('page = "route", version = "1.0.1", helper not exists => page exists, version exists, helper saved', () async {
      var args = genFullscreenModel();
      HelperEntity expectedHelperResult = genExpectedFullscreenEntity(args);
      await _testCreateHelper(args, expectedHelperResult, () => editorHelperService.saveFullScreenHelper(args));
    });

    test('page = "route", version min = "1.0.1", group not exists, version min/max not exists, helper not exists => group is created, page is created, versions are created, new helper created', () async {
      var args = genFullscreenModel(
        groupConfig: HelperGroupConfig(
          name: "my helper group 01",
          minVersion: "1.0.0",
          maxVersion: null,
        ));
      HelperEntity expectedHelperResult = genExpectedFullscreenEntity(args);
      await _testCreateHelperWithGroupAndVersionAndPage(args, expectedHelperResult, () => editorHelperService.saveFullScreenHelper(args));
    });

    test('page = "route", version = "1.0.1", helper exists => page exists, version exists, helper updated', () async {
      var args = genFullscreenModel();
      HelperEntity expectedHelperResult = genExpectedFullscreenEntity(args);
      await _testUpdateHelper(args, expectedHelperResult, () => editorHelperService.saveFullScreenHelper(args));
    });

  });

  group('[EditorHelperService] - save updateScreenHelper', () {

    setUp(() => reset(httpClientMock));

    test('page = "route", version = "1.0.1", helper not exists => page exists, version exists, helper saved', () async {
      var args = genUpdateModelData();
      HelperEntity expectedHelperResult = genExpectedUpdateEntity(args);
      await _testCreateHelper(args, expectedHelperResult, () => editorHelperService.saveUpdateHelper(args));
    });

    test('page = "route", version min and max = "1.0.1", helper not exists => page is created, version is created, new helper saved', () async {
      var argsWithNewGroup = genUpdateModelData(
        groupConfig: HelperGroupConfig(
          name: "my helper group 01",
          minVersion: "1.0.0",
          maxVersion: null,
        ));
      HelperEntity expectedHelperResult = genExpectedUpdateEntity(argsWithNewGroup);
      await _testCreateHelperWithGroupAndVersionAndPage(argsWithNewGroup, expectedHelperResult, () => editorHelperService.saveUpdateHelper(argsWithNewGroup));
    });

    test('page = "route", version = "1.0.1", helper exists => page exists, version exists, helper updated', () async {
      var args = genUpdateModelData();
      HelperEntity expectedHelperResult = genExpectedUpdateEntity(args);
      await _testUpdateHelper(args, expectedHelperResult, () => editorHelperService.saveUpdateHelper(args));
    });

  });

  group('[EditorHelperService] - save anchoredHelper', () {

    setUp(() => reset(httpClientMock));

    test('page = "route", version = "1.0.1", helper not exists => page exists, version exists, helper saved', () async {
      var args = generateAnchoredHelperData();
      HelperEntity expectedHelperResult = genExpectedHelperEntity(args);
      await _testCreateHelper(args, expectedHelperResult, () => editorHelperService.saveAnchoredWidget(args));
    });

    test('page = "route", version min and max = "1.0.1", helper not exists => page is created, version is created, new helper saved', () async {
      var argsWithNewGroup = generateAnchoredHelperData(
        helperGroupConfig: HelperGroupConfig(
          name: "my helper group 01",
          minVersion: "1.0.0",
          maxVersion: null,
        )
      );
      HelperEntity expectedHelperResult = genExpectedHelperEntity(argsWithNewGroup);
      await _testCreateHelperWithGroupAndVersionAndPage(argsWithNewGroup, expectedHelperResult, () => editorHelperService.saveAnchoredWidget(argsWithNewGroup));
    });

    test('page = "route", version = "1.0.1", helper exists => page exists, version exists, helper updated', () async {
      var args = generateAnchoredHelperData();
      HelperEntity expectedHelperResult = genExpectedHelperEntity(args);
      await _testUpdateHelper(args, expectedHelperResult, () => editorHelperService.saveAnchoredWidget(args));
    });

  });

}