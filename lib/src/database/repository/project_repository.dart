import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:pal/src/database/adapter/page_entity_adapter.dart';
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/database/repository/base_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';

class ProjectRepository extends BaseHttpRepository {
  final PageEntityAdapter _adapter = PageEntityAdapter();

  ProjectRepository({@required HttpClient httpClient})
      : super(httpClient: httpClient);

  Future<PageEntity> createAppIcon(
    String projectId,
    Uint8List imageData,
    String imageType,
    DateTime imageDate,
  ) async {
    var result = await httpClient
        .multipartImage(
          'settings',
          fileData: imageData.toList(),
          imageType: imageType,
          fileFieldName: 'appicon',
          filename: 'appicon',
        )
        .timeout(Duration(seconds: 60))
        .catchError((onError) {
          throw 'ERROR_UPLOADING_APP_ICON';
        });
    var stream = result.stream.transform(utf8.decoder);
    var jsonResult = await stream.first;
    if (result.statusCode >= 300) {
      print(' reason : $jsonResult');
      throw 'ERROR_UPLOADING_APP_ICON';
    }
    return _adapter.parse(jsonResult);
  }

  Future<PageEntity> updateAppIcon(
    String projectId,
    Uint8List imageData,
    String imageType,
    DateTime imageDate,
  ) async {
    var result = await httpClient
        .multipartImage(
          'settings',
          fileData: imageData.toList(),
          imageType: imageType,
          fileFieldName: 'appicon',
          filename: 'appicon',
          httpMethod: 'PUT',
        )
        .timeout(Duration(seconds: 60))
        .catchError((onError) {
          throw 'ERROR_UPLOADING_APP_ICON';
        });
    var stream = result.stream.transform(utf8.decoder);
    var jsonResult = await stream.first;
    if (result.statusCode >= 300) {
      print(' reason : $jsonResult');
      throw 'ERROR_UPLOADING_APP_ICON';
    }
    return _adapter.parse(jsonResult);
  }

}
