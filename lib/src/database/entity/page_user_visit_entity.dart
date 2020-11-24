import 'package:hive/hive.dart';

part 'page_user_visit_entity.g.dart';

@HiveType(typeId: 9)
class HelperGroupUserVisitEntity {

  @HiveField(0)
  String pageId;

  @HiveField(1)
  String helperGroupId;

  HelperGroupUserVisitEntity({this.pageId, this.helperGroupId});
}