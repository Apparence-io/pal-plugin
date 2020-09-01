import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:palplugin/src/database/adapter/in_app_user_storage_adapter.dart';
import 'package:palplugin/src/database/entity/in_app_user_entity.dart';
import 'package:palplugin/src/database/repository/base_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

class InAppUserRepository extends BaseHttpRepository {
  InAppUserRepository({@required HttpClient httpClient})
      : super(httpClient: httpClient);

  Future<InAppUserEntity> create(final InAppUserEntity inAppUser) async {
    final Response response =
        await this.httpClient.post("/client/in-app-users");
    return InAppUserEntityAdapter().parse(response.body);
  }

  Future<InAppUserEntity> update(final InAppUserEntity inAppUser) async {
    final Response response = await this.httpClient.put("/client/in-app-users");
    return InAppUserEntityAdapter().parse(response.body);
  }
}
