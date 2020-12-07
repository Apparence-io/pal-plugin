import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/database/adapter/helper_entity_adapter.dart' as EntityAdapter;
import 'package:pal/src/database/adapter/page_entity_adapter.dart' as PageEntityAdapter;
import 'package:pal/src/database/adapter/version_entity_adapter.dart' as VersionEntityAdapter;
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/database/entity/version_entity.dart';
import 'package:pal/src/database/repository/editor/helper_editor_repository.dart';
import 'package:pal/src/database/repository/page_repository.dart';
import 'package:pal/src/database/repository/version_repository.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/http_client/base_client.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {

  HttpClientMock httpClientMock = HttpClientMock();

  EditorHelperService editorHelperService = EditorHelperService.fromDependencies(
    EditorHelperRepository(httpClient: httpClientMock),
    VersionHttpRepository(httpClient: httpClientMock),
    PageRepository(httpClient: httpClientMock)
  );

  _testCreateHelper(dynamic args, HelperEntity expectedHelperResult, Function creationCall) async {
    // mock get page request
    PageEntity existingPage = PageEntity(id: "IUEZOUEA", creationDate: DateTime.now(), lastUpdateDate: DateTime.now(), route: args.config.route);
    var pageResJson = PageEntityAdapter.PageEntityAdapter().toJson(existingPage);
    var pageablePageResJson = '{"content":[$pageResJson], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    //var pageReqJson = jsonEncode({'name': args.config.route});
    when(httpClientMock.get('editor/pages?route=${args.config.route}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(pageablePageResJson, 200)));
    // mock get min version request
    VersionEntity versionEntity = VersionEntity(id: 25, name: args.config.minVersion);
    var versionReqJson = VersionEntityAdapter.VersionEntityAdapter().toJson(versionEntity);
    var versionPageJson = '{"content":[$versionReqJson], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    when(httpClientMock.get('editor/versions?versionName=${args.config.minVersion}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(versionPageJson, 200)));
    // mock save helper
    var expectedHelperResultJson = EntityAdapter.HelperEntityAdapter().toJson(expectedHelperResult..id = null);
    when(httpClientMock.post('editor/pages/${existingPage.id}/helpers', body: expectedHelperResultJson))
      .thenAnswer((_) => Future.value(Response(expectedHelperResultJson, 200)));
    await creationCall();
    verify(httpClientMock.post('editor/pages/${existingPage.id}/helpers', body: expectedHelperResultJson))
      .called(1);
  }

  _testCreateHelperWithVersionAndPage(dynamic args, HelperEntity expectedHelperResult, Function creationCall) async {
    // mock get page request then create page
    PageEntity existingPage = PageEntity(id: "IUEZOUEA", creationDate: DateTime.now(), lastUpdateDate: DateTime.now(), route: args.config.route);
    var pageResJson = PageEntityAdapter.PageEntityAdapter().toJson(existingPage);
    var pageablePageResJson = '{"content":[], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    var pageCreationReqJson = jsonEncode({'route': args.config.route});
    when(httpClientMock.get('editor/pages?route=${args.config.route}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(pageablePageResJson, 200)));
    when(httpClientMock.post('editor/pages', body: pageCreationReqJson)).thenAnswer((_) => Future.value(Response(pageResJson, 200)));
    // mock get min version request then create
    VersionEntity versionEntity = VersionEntity(id: 25, name: args.config.minVersion);
    var versionReqJson = VersionEntityAdapter.VersionEntityAdapter().toJson(versionEntity);
    var versionMinCreationReqJson = jsonEncode({'name': args.config.minVersion});
    var versionPageJson = '{"content":[], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    when(httpClientMock.get('editor/versions?versionName=${args.config.minVersion}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(versionPageJson, 200)));
    when(httpClientMock.post('editor/versions', body: versionMinCreationReqJson)).thenAnswer((_) => Future.value(Response(versionReqJson, 200)));
    // mock save helper
    var expectedHelperResultJson = EntityAdapter.HelperEntityAdapter().toJson(HelperEntity.copy(expectedHelperResult)..id = null);
    when(httpClientMock.post('editor/pages/${existingPage.id}/helpers', body: expectedHelperResultJson))
      .thenAnswer((_) => Future.value(Response(expectedHelperResultJson, 200)));
    await creationCall();
    verify(httpClientMock.post('editor/pages/${existingPage.id}/helpers', body: expectedHelperResultJson)).called(1);
    verify(httpClientMock.get('editor/pages?route=${args.config.route}&pageSize=1')).called(1);
    verify(httpClientMock.post('editor/pages', body: pageCreationReqJson)).called(1);
    verify(httpClientMock.get('editor/versions?versionName=${args.config.minVersion}&pageSize=1')).called(1);
    verify(httpClientMock.post('editor/versions', body: versionMinCreationReqJson)).called(1);
  }

  _testUpdateHelper(dynamic args, HelperEntity expectedHelperResult, Function updateCall) async {
    // mock get page request
    PageEntity existingPage = PageEntity(id: "IUEZOUEA", creationDate: DateTime.now(), lastUpdateDate: DateTime.now(), route: args.config.route);
    var pageResJson = PageEntityAdapter.PageEntityAdapter().toJson(existingPage);
    var pageablePageResJson = '{"content":[$pageResJson], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    //var pageReqJson = jsonEncode({'name': args.config.route});
    when(httpClientMock.get('editor/pages?route=${args.config.route}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(pageablePageResJson, 200)));
    // mock get min version request
    VersionEntity versionEntity = VersionEntity(id: 25, name: args.config.minVersion);
    var versionReqJson = VersionEntityAdapter.VersionEntityAdapter().toJson(versionEntity);
    var versionPageJson = '{"content":[$versionReqJson], "numberOfElements":1, "first":true, "last": true, "totalPages":1, "totalElements":1, "pageable": { "offset":1, "pageNumber":1, "pageSize":1 }}';
    when(httpClientMock.get('editor/versions?versionName=${args.config.minVersion}&pageSize=1'))
      .thenAnswer((_) => Future.value(Response(versionPageJson, 200)));
    // mock save helper
    var expectedHelperResultJson = EntityAdapter.HelperEntityAdapter().toJson(expectedHelperResult..id = "JDLSKJDSD");
    args.config.id = expectedHelperResult.id;
    when(httpClientMock.put('editor/pages/${existingPage.id}/helpers/${args.config.id}', body: expectedHelperResultJson))
      .thenAnswer((_) => Future.value(Response(expectedHelperResultJson, 200)));
    await updateCall();
    verify(httpClientMock.put('editor/pages/${existingPage.id}/helpers/${args.config.id}', body: expectedHelperResultJson))
      .called(1);
  }

  group('[EditorHelperService] - save simpleHelper', () {

    var args = CreateSimpleHelper(
      boxConfig: HelperBoxConfig(color: '#FFF'),
      titleText: HelperTextConfig(
        text: "Today tips is now this lorem ipsum lorem ipsum...",
        fontColor: "#CCC",
        fontWeight: "w100",
        fontSize: 21,
        fontFamily: "cortana",
      ),
      config: CreateHelperConfig(
        name: 'my helper name',
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        priority: 1,
        minVersion: "1.0.0",
        maxVersion: "1.0.0",
        route: "myPageRoute",
        helperType: HelperType.SIMPLE_HELPER,
      ),
    );

    HelperEntity expectedHelperResult = HelperEntity(
      id: "JDLSKJDSD",
      name: 'my helper name',
      type: HelperType.SIMPLE_HELPER,
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      priority: 1,
      versionMinId: 25,
      versionMaxId: 25,
      helperTexts: [
        HelperTextEntity(
          fontColor: "#CCC",
          fontWeight: "w100",
          fontSize: 21,
          value: "Today tips is now this lorem ipsum lorem ipsum...",
          fontFamily: "cortana",
          key: SimpleHelperKeys.CONTENT_KEY,
        )
      ],
      helperBoxes: [
        HelperBoxEntity(
          backgroundColor: "#FFF",
          key: SimpleHelperKeys.BACKGROUND_KEY,
        )
      ]);

    setUp(() => reset(httpClientMock));

    test('page = "route", version = "1.0.1", helper not exists => page exists, version exists, helper saved', () async {
      await _testCreateHelper(args, expectedHelperResult, () => editorHelperService.saveSimpleHelper(args));
    });

    test('page = "route", version min and max = "1.0.1", helper not exists => page is created, version is created, new helper saved', () async {
      await _testCreateHelperWithVersionAndPage(args, expectedHelperResult, () => editorHelperService.saveSimpleHelper(args));
    });

    test('page = "route", version = "1.0.1", helper exists => page exists, version exists, helper updated', () async {
      await _testUpdateHelper(args, expectedHelperResult, () => editorHelperService.saveSimpleHelper(args));
    });

  });

  group('[EditorHelperService] - save fullScreenHelper', () {
      // the args of our service creation method
      var args = CreateFullScreenHelper(
        config: CreateHelperConfig(
          name: 'my helper name',
          triggerType: HelperTriggerType.ON_SCREEN_VISIT,
          priority: 1,
          minVersion: "1.0.0",
          maxVersion: "1.0.0",
          route: "myPageRoute",
          helperType: HelperType.HELPER_FULL_SCREEN,
        ),
        title: HelperTextConfig(
            text: "Today tips is now this lorem ipsum lorem ipsum...",
            fontColor: "#CCC",
            fontWeight: "w100",
            fontSize: 21,
            fontFamily: "cortana"),
        description: HelperTextConfig(
            text: "Description lorem ipsum...",
            fontColor: "#CCC2",
            fontWeight: "w400",
            fontSize: 14,
            fontFamily: "cortanaBis"),
        bodyBox: HelperBoxConfig(
          color: '#CCF',
        ),
        mediaHeader: HelperMediaConfig(url: "http://image.png/"),
      );

      HelperEntity expectedHelperResult = HelperEntity(
        id: "JDLSKJDSD",
        name: args.config.name,
        type: HelperType.HELPER_FULL_SCREEN,
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        priority: 1,
        versionMinId: 25,
        versionMaxId: 25,
        helperTexts: [
          HelperTextEntity(
            value: args.title.text,
            fontColor: args.title.fontColor,
            fontWeight: args.title.fontWeight,
            fontSize: args.title.fontSize,
            fontFamily: args.title.fontFamily,
            key: FullscreenHelperKeys.TITLE_KEY,
          ),
          HelperTextEntity(
            value: args.description.text,
            fontColor: args.description.fontColor,
            fontWeight: args.description.fontWeight,
            fontSize: args.description.fontSize,
            fontFamily: args.description.fontFamily,
            key: FullscreenHelperKeys.DESCRIPTION_KEY,
          ),
        ],
        helperImages: [
          HelperImageEntity(
            url: args.mediaHeader.url,
            key: FullscreenHelperKeys.IMAGE_KEY,
          )
        ],
        helperBoxes: [
          HelperBoxEntity(
            key: FullscreenHelperKeys.BACKGROUND_KEY,
            backgroundColor: args.bodyBox.color,
          )
        ],
      );

      setUp(() => reset(httpClientMock));

      test('page = "route", version = "1.0.1", helper not exists => page exists, version exists, helper saved', () async {
        await _testCreateHelper(args, expectedHelperResult, () => editorHelperService.saveFullScreenHelper(args));
      });

      test('page = "route", version min and max = "1.0.1", helper not exists => page is created, version is created, new helper saved', () async {
        await _testCreateHelperWithVersionAndPage(args, expectedHelperResult, () => editorHelperService.saveFullScreenHelper(args));
      });

      test('page = "route", version = "1.0.1", helper exists => page exists, version exists, helper updated', () async {
        await _testUpdateHelper(args, expectedHelperResult, () => editorHelperService.saveFullScreenHelper(args));
      });

  });

  group('[EditorHelperService] - save updateScreenHelper', () {

    var args = CreateUpdateHelper(
      config: CreateHelperConfig(
        name: 'my helper name 2',
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        priority: 1,
        minVersion: "1.0.0",
        maxVersion: "1.0.0",
        route: "myPageRoute",
        helperType: HelperType.UPDATE_HELPER,
      ),
      title: HelperTextConfig(
        text: "Today tips is now this lorem ipsum lorem ipsum...",
        fontColor: "#CCC",
        fontWeight: "w100",
        fontSize: 21,
        fontFamily: "cortana",
      ),
      lines: [
        HelperTextConfig(
          text: "Line 1",
          fontColor: "#CCC2",
          fontWeight: "w100E",
          fontSize: 212,
          fontFamily: "cortana2",
        ),
        HelperTextConfig(
          text: "Line 2",
          fontColor: "#CCC2",
          fontWeight: "w100E",
          fontSize: 212,
          fontFamily: "cortana2",
        )
      ],
      bodyBox: HelperBoxConfig(color: '#CCF'),
      headerMedia: HelperMediaConfig(url: 'url'),
    );

    // what our service should create
    HelperEntity expectedHelperResult = HelperEntity(
        name: args.config.name,
        type: HelperType.UPDATE_HELPER,
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        priority: 1,
        versionMinId: 25,
        versionMaxId: 25,
        helperTexts: [
          HelperTextEntity(
            value: args.title.text,
            fontColor: args.title.fontColor,
            fontWeight: args.title.fontWeight,
            fontSize: args.title.fontSize,
            fontFamily: args.title.fontFamily,
            key: UpdatescreenHelperKeys.TITLE_KEY,
          ),
          HelperTextEntity(
            value: args.lines[0].text,
            fontColor: args.lines[0].fontColor,
            fontWeight: args.lines[0].fontWeight,
            fontSize: args.lines[0].fontSize,
            fontFamily: args.lines[0].fontFamily,
            key: "${UpdatescreenHelperKeys.LINES_KEY}:0",
          ),
          HelperTextEntity(
            value: args.lines[1].text,
            fontColor: args.lines[1].fontColor,
            fontWeight: args.lines[1].fontWeight,
            fontSize: args.lines[1].fontSize,
            fontFamily: args.lines[1].fontFamily,
            key: "${UpdatescreenHelperKeys.LINES_KEY}:1",
          ),
        ],
        helperImages: [
          HelperImageEntity(
            url: args.headerMedia.url,
            key: FullscreenHelperKeys.IMAGE_KEY,
          )
        ],
        helperBoxes: [
          HelperBoxEntity(
            key: FullscreenHelperKeys.BACKGROUND_KEY,
            backgroundColor: args.bodyBox.color,
          )
        ]);

    setUp(() => reset(httpClientMock));

    test('page = "route", version = "1.0.1", helper not exists => page exists, version exists, helper saved', () async {
      await _testCreateHelper(args, expectedHelperResult, () => editorHelperService.saveUpdateHelper(args));
    });

    test('page = "route", version min and max = "1.0.1", helper not exists => page is created, version is created, new helper saved', () async {
      await _testCreateHelperWithVersionAndPage(args, expectedHelperResult, () => editorHelperService.saveUpdateHelper(args));
    });

    test('page = "route", version = "1.0.1", helper exists => page exists, version exists, helper updated', () async {
      await _testUpdateHelper(args, expectedHelperResult, () => editorHelperService.saveUpdateHelper(args));
    });

  });
}