import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:palplugin/database/adapter/helper_entity_adapter.dart';
import 'package:palplugin/database/entity/helper_entity.dart';
import 'package:palplugin/database/entity/pageable.dart';
import 'package:palplugin/database/repository/editor/base_repository.dart';
import 'package:palplugin/service/http_client/base_client.dart';

class HelperRepository extends BaseHttpRepository {
  final HelperEntityAdapter _adapter = HelperEntityAdapter();

  HelperRepository({@required HttpClient httpClient})
      : super(httpClient: httpClient);

  Future<Pageable<HelperEntity>> getHelpers(final String route) async {
    final Response response =
        await this.httpClient.get("/pages/helpers?route=$route");
    return this._adapter.parsePage(response.body);
  }
}
