import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/repository/base_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';

abstract class ClientSchemaRepository {

  /// if [schemaVersion] is null returns the current schemaEntity
  /// if [schemaVersion] is provided and repository contains an upper version returns the current SchemaEntity
  /// if [schemaVersion] is provided and repository contains a lower or equal version returns nothing
  /// if [language] is null, returns the default language
  /// if [appVersion] must be provided, current application version in user pubspec.yml
  Future<SchemaEntity> get({int schemaVersion, String language, String appVersion});

}


class ClientSchemaRemoteRepository extends BaseHttpRepository implements ClientSchemaRepository {

  ClientSchemaRemoteRepository({@required HttpClient httpClient})
    : super(httpClient: httpClient);

  @override
  Future<SchemaEntity> get({int schemaVersion, String language, @required String appVersion}) {
    // TODO: implement get
    throw UnimplementedError();
  }

}

class ClientSchemaLocalRepository implements ClientSchemaRepository {

  final Future<Box<SchemaEntity>> _hiveBoxOpener;

  ClientSchemaLocalRepository({Future<Box<SchemaEntity>> hiveBoxOpener})
    : this._hiveBoxOpener = hiveBoxOpener;

  @override
  Future<SchemaEntity> get({int schemaVersion, String language, String appVersion}) async {
    var _hiveBox = await _hiveBoxOpener;
    if(_hiveBox.isEmpty)
      return null;
    return _hiveBox.values.first;
  }

  Future<void> save(SchemaEntity schema) async {
    var _hiveBox = await _hiveBoxOpener;
    await _hiveBox.clear();
    await _hiveBox.add(schema);
  }

  Future<void> clear() async {
    var _hiveBox = await _hiveBoxOpener;
    await _hiveBox.clear();
  }

}