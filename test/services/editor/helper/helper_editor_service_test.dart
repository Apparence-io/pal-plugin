import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/database/adapter/helper_entity_adapter.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/database/repository/editor/helper_editor_repository.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/http_client/base_client.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  group('EditorHelperService', () {
    HttpClientMock httpClientMock = HttpClientMock();
    EditorHelperService editorHelperService = EditorHelperService.build(
        EditorHelperRepository(httpClient: httpClientMock));

    setUp(() {
      reset(httpClientMock);
    });

    test(
        '[SimpleHelper] create an helper should call editor helper API and return entity',
        () async {
      var pageId = 'DJKLSQLKDJLQ132154a';
      // the args of our service creation method
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
          versionMinId: 25, //FIXME
          versionMaxId: 25, //FIXME
          pageId: '',
          helperType: HelperType.SIMPLE_HELPER,
        ),
      );
      // the entity creation request that our service should create
      HelperEntity myHelper = HelperEntity(
          name: 'my helper name',
          type: HelperType.SIMPLE_HELPER,
          triggerType: HelperTriggerType.ON_SCREEN_VISIT,
          priority: 1,
          versionMinId: 25, //FIXME
          versionMaxId: 25, //FIXME
          pageId: pageId,
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
      // what http will result
      HelperEntity resHelper = HelperEntity.copy(myHelper)..id = "820938203";
      var resHelperJson = HelperEntityAdapter().toJson(resHelper);
      var reqHelperJson = HelperEntityAdapter().toJson(myHelper);
      when(httpClientMock.post('editor/pages/$pageId/helpers',
              body: reqHelperJson))
          .thenAnswer((_) => Future.value(Response(resHelperJson, 200)));
      // call the service part
      var resultEntity =
          await editorHelperService.createSimpleHelper(pageId, args);
      expect(resultEntity, isNotNull,
          reason: "The service didn't create entity properly");
      expect(resultEntity.id, equals("820938203"));
    });

    test(
        '[FullscreenHelper] create an helper should call editor helper API and return entity',
        () async {
      var pageId = 'DJKLSQLKDJLQ132154a';
      // the args of our service creation method
      var args = CreateFullScreenHelper(
          config: CreateHelperConfig(
            pageId: '',
            helperType: HelperType.HELPER_FULL_SCREEN,
            name: 'my helper name 2',
            triggerType: HelperTriggerType.ON_SCREEN_VISIT,
            priority: 1,
            versionMinId: 25, //FIXME
            versionMaxId: 25, //FIXME
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
          backgroundColor: "#CCF",
          topImageUrl: "http://image.png/");
      // what our service should create from the args
      HelperEntity myHelper = HelperEntity(
          name: args.config.name,
          type: HelperType.HELPER_FULL_SCREEN,
          triggerType: HelperTriggerType.ON_SCREEN_VISIT,
          priority: 1,
          versionMinId: 25, //FIXME
          versionMaxId: 25, //FIXME
          pageId: pageId,
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
                url: args.topImageUrl, key: FullscreenHelperKeys.IMAGE_KEY)
          ],
          helperBoxes: [
            HelperBoxEntity(
                key: FullscreenHelperKeys.BACKGROUND_KEY,
                backgroundColor: args.backgroundColor)
          ]);
      // what http will result
      HelperEntity resHelper = HelperEntity.copy(myHelper)..id = "820938203";
      var reqHelperJson = HelperEntityAdapter().toJson(myHelper);
      var resHelperJson = HelperEntityAdapter().toJson(resHelper);
      when(httpClientMock.post('editor/pages/$pageId/helpers',
              body: reqHelperJson))
          .thenAnswer((_) => Future.value(Response(resHelperJson, 200)));
      // call the service part
      var resultEntity =
          await editorHelperService.createFullScreenHelper(pageId, args);
      expect(resultEntity, isNotNull,
          reason: "The service didn't create entity properly");
    });

    test(
        '[UpdateHelper] create an updateHelper should call editor helper API and return entity',
        () async {
      var pageId = 'DJKLSQLKDJLQ132154a';
      // the args of our service creation method
      var args = CreateUpdateHelper(
          config: CreateHelperConfig(
            name: 'my helper name 2',
            triggerType: HelperTriggerType.ON_SCREEN_VISIT,
            priority: 1,
            versionMinId: 25, //FIXME
            versionMaxId: 25, //FIXME
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
          backgroundColor: "#CCF",
          topImageUrl: 'url');
      // what our service should create
      HelperEntity myHelper = HelperEntity(
          name: args.config.name,
          type: HelperType.UPDATE_HELPER,
          triggerType: HelperTriggerType.ON_SCREEN_VISIT,
          priority: 1,
          versionMinId: 25, //FIXME
          versionMaxId: 25, //FIXME
          pageId: pageId,
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
                url: args.topImageUrl, key: FullscreenHelperKeys.IMAGE_KEY)
          ],
          helperBoxes: [
            HelperBoxEntity(
                key: FullscreenHelperKeys.BACKGROUND_KEY,
                backgroundColor: args.backgroundColor)
          ]);
      // what http will result
      HelperEntity resHelper = HelperEntity.copy(myHelper)..id = "820938203";
      var reqHelperJson = HelperEntityAdapter().toJson(myHelper);
      var resHelperJson = HelperEntityAdapter().toJson(resHelper);
      when(httpClientMock.post('editor/pages/$pageId/helpers',
              body: reqHelperJson))
          .thenAnswer((_) => Future.value(Response(resHelperJson, 200)));
      // call the service part
      var resultEntity =
          await editorHelperService.createUpdateHelper(pageId, args);
      expect(resultEntity, isNotNull,
          reason: "The service didn't create entity properly");
    });
  });
}
