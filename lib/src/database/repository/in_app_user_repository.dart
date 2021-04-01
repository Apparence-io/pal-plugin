import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pal/src/database/adapter/in_app_user_storage_adapter.dart';
import 'package:pal/src/database/entity/in_app_user_entity.dart';
import 'package:pal/src/database/repository/base_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';

class InAppUserRepository extends BaseHttpRepository {
  InAppUserRepository({@required HttpClient httpClient})
      : super(httpClient: httpClient);

  Future<InAppUserEntity> create(final InAppUserEntity inAppUser) async {
    try {
      final Response response = await this
          .httpClient
          .post(Uri.parse("pal-analytic/in-app-users"),
              body: InAppUserEntityAdapter().toJson(inAppUser))
          .catchError(
        (err) {
          return null;
        },
      );
      return InAppUserEntityAdapter().parse(response.body);
    } catch (e) {
      throw InternalHttpError('ERROR WHILE CREATING InAppUser $e');
    }
  }

  Future<InAppUserEntity> update(final InAppUserEntity inAppUser) async {
    final Response response = await this.httpClient.put(
        Uri.parse("pal-analytic/in-app-users/${inAppUser.id}"),
        body: InAppUserEntityAdapter().toJson(inAppUser));
    return InAppUserEntityAdapter().parse(response.body);
  }
}
