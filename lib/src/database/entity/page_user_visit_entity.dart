import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'page_user_visit_entity.g.dart';

@HiveType(typeId: 9)
class HelperGroupUserVisitEntity {

  @HiveField(0)
  String? pageId;

  @HiveField(1)
  String? helperGroupId;

  @HiveField(2)
  DateTime? visitDate;

  @HiveField(3)
  String? visitVersion;

  HelperGroupUserVisitEntity({
    required this.pageId, 
    required this.helperGroupId, 
    required this.visitDate, 
    required this.visitVersion});
}