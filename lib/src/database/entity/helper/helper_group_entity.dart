import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

import '../page_entity.dart';
import 'helper_trigger_type.dart';

part 'helper_group_entity.g.dart';

@HiveType(typeId: 2)
class HelperGroupEntity with Comparable<HelperGroupEntity> {

  @HiveField(0)
  String id;

  @HiveField(1)
  int priority;

  @HiveField(2)
  HelperTriggerType type;

  @HiveField(3)
  List<HelperEntity> helpers;

  @HiveField(4)
  PageEntity page;

  HelperGroupEntity({this.id, this.priority, this.helpers, this.page, this.type});

  @override
  int compareTo(HelperGroupEntity other) {
    if(other.type == this.type) {
      return other.priority < this.priority ? 1 : -1;
    }
    return other.type.typePriority < this.type.typePriority ? 1 : -1;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperGroupEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          priority == other.priority &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ priority.hashCode ^ type.hashCode;
}