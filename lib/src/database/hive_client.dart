
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'entity/helper/helper_entity.dart';
import 'entity/helper/helper_group_entity.dart';
import 'entity/helper/helper_type.dart';
import 'entity/helper/schema_entity.dart';
import 'entity/page_user_visit_entity.dart';
import 'entity/page_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

typedef Future<Box<T>> LocalDbOpener<T>();

class HiveClient {

  HiveClient({bool shouldInit = true}) {
    if(!shouldInit)
      return;
    init();
  }

  @visibleForTesting
  init() async {
    await Hive.initFlutter();
    initAdapters();
  }

  @visibleForTesting
  initLocal()  {
    Hive.init('localstorage');
    initAdapters();
  }

  @visibleForTesting
  initAdapters() {
    Hive.registerAdapter(SchemaEntityAdapter());
    Hive.registerAdapter(HelperGroupEntityAdapter());
    Hive.registerAdapter(HelperEntityAdapter());
    Hive.registerAdapter(PageEntityAdapter());
    Hive.registerAdapter(HelperGroupUserVisitEntityAdapter());
    Hive.registerAdapter(HelperTypeAdapter());
    Hive.registerAdapter(HelperTriggerTypeAdapter());
    Hive.registerAdapter(HelperTextEntityAdapter());
    Hive.registerAdapter(HelperImageEntityAdapter());
    Hive.registerAdapter(HelperBorderEntityAdapter());
    Hive.registerAdapter(HelperBoxEntityAdapter());
  }

  LocalDbOpener<SchemaEntity> get openSchemaBox =>
      () => Hive.openBox<SchemaEntity>('schema');

  LocalDbOpener<HelperGroupUserVisitEntity> get openVisitsBox =>
      () => Hive.openBox<HelperGroupUserVisitEntity>('visits');


  close() => Hive.close();
}