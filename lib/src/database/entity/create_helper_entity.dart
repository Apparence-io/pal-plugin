import 'package:palplugin/src/database/entity/trigger_type.dart';

abstract class CreateHelperEntity {
  String name;
  String type;
  TriggerHelper triggerType;
  int priority;

  CreateHelperEntity({this.name, this.type, this.triggerType, this.priority});
}