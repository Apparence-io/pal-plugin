import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/database/entity/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/database/entity/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper_full_screen_entity.dart';
import 'package:palplugin/src/database/entity/helper_type.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/editor/helper_repository.dart';
import 'package:palplugin/src/services/editor/helper/helper_service.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

class _HttpClientMock extends Mock implements HttpClient {}

void main() {
  group("test helper service", () {
    test("test get helpers", () async {
      final _HttpClientMock mockedHttpClient = _HttpClientMock();

      final String content = new File(
              "test/integration/services/editor/helper/resources/helpers.json")
          .readAsStringSync();
      when(mockedHttpClient.get("/pages/helpers?route=test/route"))
          .thenAnswer((_) => Future.value(
                Response(content, 200),
              ));
      final HelperRepository helperRepository =
          HelperRepository(httpClient: mockedHttpClient);
      final HelperService helperService = HelperService.build(helperRepository);

      Pageable<HelperEntity> helpers =
          await helperService.getPageHelpers("test/route");

      assert(helpers.offset == 1);
      assert(helpers.pageNumber == 0);
      assert(helpers.pageSize == 1);
      assert(helpers.first == true);
      assert(helpers.last == true);
      assert(helpers.numberOfElements == 1);
      assert(helpers.totalPages == 1);
      assert(helpers.totalElements == 1);
      assert(helpers.entities.length == 1);
      HelperFullScreenEntity entity = helpers.entities[0];
      checkReturnedHelper(entity);
    });

    test("test create helper", () async {
      final _HttpClientMock mockedHttpClient = _HttpClientMock();

      final String content = new File(
              "test/integration/services/editor/helper/resources/helper.json")
          .readAsStringSync();
      when(mockedHttpClient.post(any, body: anyNamed("body")))
          .thenAnswer((_) => Future.value(
                Response(content, 200),
              ));
      final HelperRepository helperRepository =
          HelperRepository(httpClient: mockedHttpClient);
      final HelperService helperService = HelperService.build(helperRepository);

      HelperEntity helper = await helperService.createPageHelper(
          "db6b01e1-b649-4a17-949a-9ab320600001",
          CreateHelperFullScreenEntity(
            title: "title",
            name: "title",
            languageId: 1,
            priority: 1,
            fontColor: "#FFFFFFFF",
            backgroundColor: "#FFFFFFFF",
            borderColor: "#FFFFFFFF",
            triggerType: "triggerType",
            versionMaxId: 1,
            versionMinId: 2,
          ));

      checkReturnedHelper(helper);
    });
  });
}

void checkReturnedHelper(HelperFullScreenEntity helper) {
  assert(helper.id == "db6b01e1-b649-4a17-949a-9ab320601001");
  assert(helper.name == "Helper test 1");
  assert(helper.type == HelperType.HELPER_FULL_SCREEN);
  assert(helper.triggerType == "on_start");
  assert(helper.creationDate ==
      DateTime.parse("2019-10-30 17:30:00.000-06:30").toLocal());
  assert(helper.lastUpdateDate ==
      DateTime.parse("2019-10-30 17:30:00.000-06:30").toLocal());
  assert(helper.priority == 1);
  assert(helper.pageId == "db6b01e1-b649-4a17-949a-9ab320600001");
  assert(helper.versionMinId == 1);
  assert(helper.versionMin == "1.0.1");
  assert(helper.versionMaxId == 2);
  assert(helper.versionMax == "1.0.2");
  assert(helper.title == "title");
  assert(helper.fontColor == "#FFFFFFFF");
  assert(helper.borderColor == "#FFFFFFFF");
  assert(helper.borderColor == "#FFFFFFFF");
  assert(helper.languageId == 1);
}
