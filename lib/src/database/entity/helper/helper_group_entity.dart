import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';

import '../page_entity.dart';

part 'helper_group_entity.g.dart';

@HiveType(typeId: 2)
class HelperGroupEntity {

  @HiveField(0)
  String id;

  @HiveField(1)
  int priority;

  @HiveField(2)
  List<HelperEntity> helpers;

  @HiveField(3)
  PageEntity page;

  @HiveField(4)
  String name;

  @HiveField(5)
  HelperTriggerType triggerType;

  @HiveField(6)
  DateTime creationDate;

  @HiveField(7)
  String minVersion;

  @HiveField(8)
  String maxVersion;

  HelperGroupEntity({
    this.id, 
    this.priority, 
    this.helpers, 
    this.page, 
    this.name, 
    this.triggerType, 
    this.creationDate,
    this.minVersion,
    this.maxVersion
  });
}