
import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';

import '../page_entity.dart';
import 'helper_trigger_type.dart';

part 'helper_group_entity.g.dart';

@HiveType(typeId: 2)
class HelperGroupEntity with Comparable<HelperGroupEntity> {

  @HiveField(0)
  String? id;

  @HiveField(1)
  int? priority;

  @HiveField(2)
  List<HelperEntity>? helpers;

  @HiveField(3)
  PageEntity? page;

  @HiveField(4)
  String? name;

  @HiveField(5)
  HelperTriggerType? triggerType;

  @HiveField(6)
  DateTime? creationDate;

  @HiveField(7)
  String? minVersion;

  @HiveField(8)
  String? maxVersion;

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

  @override
  int compareTo(HelperGroupEntity other) {
    if(other.triggerType == this.triggerType) {
      return other.priority! < this.priority! ? 1 : -1;
    }
    return other.triggerType.typePriority < this.triggerType.typePriority ? 1 : -1;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperGroupEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          priority == other.priority &&
          triggerType == other.triggerType;

  @override
  int get hashCode => id.hashCode ^ priority.hashCode ^ triggerType.hashCode;
}