import 'package:palplugin/src/database/entity/helper_type.dart';

abstract class CreateHelperEntity {
  String name;
  HelperType type;
  String triggerType;
  int priority;

  CreateHelperEntity({this.name, this.type, this.triggerType, this.priority});
}