import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:pal/src/database/adapter/generic_adapter.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/repository/base_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';
import 'package:pal/src/database/adapter/schema_entity_adapter.dart' as Adapter;

import '../../hive_client.dart';

abstract class ClientSchemaRepository {

  /// if [schemaVersion] is null returns the current schemaEntity
  /// if [schemaVersion] is provided and repository contains an upper version returns the current SchemaEntity
  /// if [schemaVersion] is provided and repository contains a lower or equal version returns nothing
  /// if [language] is null, returns the default language
  /// if [appVersion] must be provided, current application version in user pubspec.yml
  Future<SchemaEntity> get({int schemaVersion, String language, String appVersion});

}


class ClientSchemaRemoteRepository extends BaseHttpRepository implements ClientSchemaRepository {

  GenericEntityAdapter<SchemaEntity> _adapter = Adapter.SchemaEntityAdapter();

  ClientSchemaRemoteRepository({@required HttpClient httpClient})
    : super(httpClient: httpClient);

  @override
  Future<SchemaEntity> get({int schemaVersion, String language, @required String appVersion}) async {
    final Response response = await this
      .httpClient
      .get('client/schema?languageCode=$language', headers: {
        'appVersion': appVersion,
        'schemaVersion': schemaVersion != null ? schemaVersion.toString() : ''
      });
    if(response.body.isNotEmpty) {
      return this._adapter.parse(response.body);
    }
    return null;
  }

}

class ClientSchemaLocalRepository implements ClientSchemaRepository {

  final LocalDbOpener<SchemaEntity> _hiveBoxOpener;

  ClientSchemaLocalRepository({ LocalDbOpener<SchemaEntity> hiveBoxOpener})
    : this._hiveBoxOpener = hiveBoxOpener;

  @override
  Future<SchemaEntity> get({int schemaVersion, String language, String appVersion}) async {
    var _hiveBox = await _hiveBoxOpener();
    if(_hiveBox.isEmpty)
      return null;
    return _hiveBox.values.first;
  }

  Future<void> save(SchemaEntity schema) async {
    var _hiveBox = await _hiveBoxOpener();
    await _hiveBox.clear();
    await _hiveBox.add(schema);
  }

  Future<void> clear() async {
    var _hiveBox = await _hiveBoxOpener();
    await _hiveBox.clear();
  }

}