import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';

abstract class ClientSchemaRepository {

  /// if [schemaVersion] is null returns the current schemaEntity
  /// if [schemaVersion] is provided and repository contains an upper version returns the current SchemaEntity
  /// if [schemaVersion] is provided and repository contains a lower or equal version returns nothing
  /// if [language] is null, returns the default language
  /// if [appVersion] must be provided, current application version in user pubspec.yml
  Future<SchemaEntity> get({int schemaVersion, String language, @required String appVersion});

}


class ClientSchemaRemoteRepository implements ClientSchemaRepository {

  @override
  Future<SchemaEntity> get({int schemaVersion, String language, @required String appVersion}) {
    // TODO: implement get
    throw UnimplementedError();
  }

}

class ClientSchemaLocalRepository implements ClientSchemaRepository {

  Box<SchemaEntity> _hiveBox;

  ClientSchemaLocalRepository() {
    _init();
  }

  _init() async {
    Hive.init('localstorage'); //TODO move this
    Hive.registerAdapter(SchemaEntityAdapter());
    Hive.registerAdapter(HelperGroupEntityAdapter());
    Hive.registerAdapter(HelperEntityAdapter());
    _hiveBox = await Hive.openBox<SchemaEntity>('schema');
  }

  @override
  Future<SchemaEntity> get({int schemaVersion, String language, @required String appVersion}) async {
    if(_hiveBox.isEmpty)
      return null;
    return _hiveBox.values.first;
  }

  Future<void> save(SchemaEntity schema) async {
    await _hiveBox.clear();
    await _hiveBox.add(schema);
  }

  Future<void> clear() async {
    await _hiveBox.clear();
  }

}