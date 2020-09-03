import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/entity/version_entity.dart';
import 'package:palplugin/src/database/repository/version_repository.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/services/editor/versions/version_editor_service.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

class HttpClientMock extends Mock implements HttpClient {} 

class PackageVersionReaderMock extends Mock implements PackageVersionReader {}

void main() {
  group('test', () {

    HttpClient httpClientMock = HttpClientMock();

    PackageVersionReaderMock packageVersionReaderMock = PackageVersionReaderMock();

    VersionRepository versionRepository = VersionHttpRepository(httpClient: httpClientMock);

    VersionEditorService versionEditorService = VersionEditorService.build(
      versionRepository: versionRepository,
      packageVersionReader: packageVersionReaderMock
    );

    test('get current version entity', () async {
      var versionNumber = "1.0.0";
      var expectedModel = {
        "content": [
          {
            "id": 1,
            "name": "1.0.0"
          }
        ],
        "empty": false,
        "first": true,
        "last": true,
        "number": 1,
        "numberOfElements": 1,
        "pageable": {
          "offset": 0,
          "pageNumber": 1,
          "pageSize": 1,
          "paged": true,
          "sort": {
            "empty": true,
            "sorted": true,
            "unsorted": true
          },
          "unpaged": true
        },
        "size": 1,
        "sort": {
          "empty": true,
          "sorted": true,
          "unsorted": true
        },
        "totalElements": 1,
        "totalPages": 1
      };

      when(packageVersionReaderMock.version).thenReturn(versionNumber);
      when(httpClientMock.get('editor/versions?versionName=$versionNumber&pageSize=10'))
        .thenAnswer((_) async => http.Response(jsonEncode(expectedModel), 200));
      var currentVersionEntity = await versionEditorService.getCurrentVersion();
      expect(currentVersionEntity, isNotNull);
      expect(currentVersionEntity, SameVersion(equals(versionNumber)));
    });

    test('get all available versions', () async {
      var expectedModel = {
        "content": [
          {
            "id": 1,
            "name": "1.0.0"
          },
          {
            "id": 2,
            "name": "2.0.0"
          },
          {
            "id": 3,
            "name": "3.0.0"
          }
        ],
        "numberOfElements": 3,
        "pageable": {
          "offset": 0,
          "pageNumber": 1,
          "pageSize": 1,
          "paged": true,
          "sort": {
            "empty": true,
            "sorted": true,
            "unsorted": true
          },
          "unpaged": true
        },
        "size": 1000,
        "totalElements": 3,
        "totalPages": 1
      };
      when(httpClientMock.get('editor/versions?versionName=&pageSize=1000'))
        .thenAnswer((_) async => http.Response(jsonEncode(expectedModel), 200));

      List<VersionEntity> allVersions = await versionEditorService.getAll();
      expect(allVersions, isNotNull);
      expect(allVersions.length, equals(3));
      expect(allVersions[0].name, equals("1.0.0"));
      expect(allVersions[1].name, equals("2.0.0"));
      expect(allVersions[2].name, equals("3.0.0"));
    });

  });
}

class SameVersion extends CustomMatcher {
  SameVersion(matcher)
    : super("version entity equal matcher", "versionEntity", matcher);

  @override
  featureValueOf(actual) => (actual as VersionEntity).name;
}