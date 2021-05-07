
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/in_app_user_entity.dart';
import 'entity/helper/helper_entity.dart';
import 'entity/helper/helper_group_entity.dart';
import 'entity/helper/helper_type.dart';
import 'entity/helper/schema_entity.dart';
import 'entity/page_user_visit_entity.dart';
import 'entity/page_entity.dart';

typedef Future<Box<T>> LocalDbOpener<T>();

class HiveClient {

  HiveClient({bool shouldInit = true}) {
    if(!shouldInit)
      return;
    init();
  }

  @visibleForTesting
  init() async {
    initAdapters();
  }

  @visibleForTesting
  initLocal()  {
    Hive.init('localstorage');
    initAdapters();
  }

  @visibleForTesting
  initAdapters() {
    Hive.registerAdapter(SchemaEntityAdapter(), override: true);
    Hive.registerAdapter(HelperGroupEntityAdapter(), override: true);
    Hive.registerAdapter(HelperEntityAdapter(), override: true);
    Hive.registerAdapter(PageEntityAdapter(), override: true);
    Hive.registerAdapter(HelperGroupUserVisitEntityAdapter(), override: true);
    Hive.registerAdapter(HelperTypeAdapter(), override: true);
    Hive.registerAdapter(HelperTriggerTypeAdapter(), override: true);
    Hive.registerAdapter(HelperTextEntityAdapter(), override: true);
    Hive.registerAdapter(HelperImageEntityAdapter(), override: true);
    Hive.registerAdapter(HelperBorderEntityAdapter(), override: true);
    Hive.registerAdapter(HelperBoxEntityAdapter(), override: true);
    Hive.registerAdapter(InAppUserEntityAdapter(), override: true);
  }

  LocalDbOpener<SchemaEntity> get openSchemaBox =>
      () => Hive.openBox<SchemaEntity>('schema');

  LocalDbOpener<HelperGroupUserVisitEntity> get openVisitsBox =>
      () => Hive.openBox<HelperGroupUserVisitEntity>('visits');

      LocalDbOpener<InAppUserEntity> get openInAppUserBox =>
      () => Hive.openBox<InAppUserEntity>('inAppUser');


  close() => Hive.close();
}