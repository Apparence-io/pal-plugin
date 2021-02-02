import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:pal/src/database/adapter/app_icon_entity.dart';
import 'package:pal/src/database/entity/app_icon_entity.dart';
import 'package:pal/src/database/repository/base_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';

class ProjectRepository extends BaseHttpRepository {
  final AppIconEntityAdapter _adapter = AppIconEntityAdapter();

  ProjectRepository({@required HttpClient httpClient})
      : super(httpClient: httpClient);

  Future<AppIconEntity> createAppIcon(
    Uint8List imageData,
    String imageType,
  ) async {
    var result = await httpClient
        .multipartImage(
          'pal-business/editor/app-icon',
          fileData: imageData.toList(),
          imageType: imageType,
          fileFieldName: 'appIcon',
          filename: 'appIcon',
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

  Future<AppIconEntity> updateAppIcon(
    String appIconId,
    Uint8List imageData,
    String imageType,
  ) async {
    var result = await httpClient
        .multipartImage(
          'pal-business/editor/app-icon/$appIconId',
          fileData: imageData.toList(),
          imageType: imageType,
          fileFieldName: 'appIcon',
          filename: 'appIcon',
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

  Future<AppIconEntity> getAppIcon() async {
    final Response response =
        await this.httpClient.get('pal-business/editor/app-icon');
    return this._adapter.parse(response.body);
  }
}
