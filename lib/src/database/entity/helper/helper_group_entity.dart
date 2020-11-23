import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';

part 'helper_group_entity.g.dart';

@HiveType(typeId: 2)
class HelperGroupEntity {

  @HiveField(0)
  int priority;

  @HiveField(1)
  List<HelperEntity> helpers;

  HelperGroupEntity({this.priority, this.helpers});
}