import 'package:flutter/material.dart';
import 'package:palplugin/src/database/adapter/version_entity_adapter.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/entity/version_entity.dart';
import 'package:palplugin/src/database/repository/base_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

abstract class VersionRepository {

  Future<Pageable<VersionEntity>> getVersions({String name, int pageSize = 10}) => throw "not implemented yet";
}

class VersionHttpRepository extends BaseHttpRepository implements VersionRepository {

  final VersionEntityAdapter _versionEntityAdapter = VersionEntityAdapter();
  final HttpClient httpClient;

  VersionHttpRepository({@required this.httpClient}) : super(httpClient: httpClient);

  @override
  Future<Pageable<VersionEntity>> getVersions({String name = '', int pageSize = 10, }) {
    return this.httpClient.get('editor/versions?versionName=$name&pageSize=$pageSize')
      .then((res) => _versionEntityAdapter.parsePage(res.body));
  }

}