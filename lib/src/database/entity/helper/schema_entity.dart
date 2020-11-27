import 'package:hive/hive.dart';

import 'helper_group_entity.dart';

part 'schema_entity.g.dart';

@HiveType(typeId: 0)
class SchemaEntity {

  @HiveField(0)
  String projectId;

  @HiveField(1)
  List<HelperGroupEntity> groups;

  @HiveField(2)
  int schemaVersion;

  SchemaEntity({this.projectId, this.groups, this.schemaVersion});
}