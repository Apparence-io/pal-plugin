import 'package:hive/hive.dart';

import 'entity/helper/helper_entity.dart';
import 'entity/helper/helper_group_entity.dart';
import 'entity/helper/schema_entity.dart';
import 'entity/page_user_visit_entity.dart';
import 'entity/page_entity.dart';

class HiveClient {

  init() async {
    Hive.init('localstorage');
    Hive.registerAdapter(SchemaEntityAdapter());
    Hive.registerAdapter(HelperGroupEntityAdapter());
    Hive.registerAdapter(HelperEntityAdapter());
    Hive.registerAdapter(PageEntityAdapter());
    Hive.registerAdapter(PageUserVisitEntityAdapter());
  }

  Future<Box<SchemaEntity>> get openSchemaBox => Hive.openBox<SchemaEntity>('schema');

  Future<Box<HelperGroupUserVisitEntity>> get openVisitsBox => Hive.openBox<HelperGroupUserVisitEntity>('visits');

  close() => Hive.close();
}