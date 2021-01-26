import 'package:hive/hive.dart';

part 'helper_trigger_type.g.dart';

@HiveType(typeId: 11)
enum HelperTriggerType {
  @HiveField(0)
  ON_SCREEN_VISIT,
  @HiveField(1)
  AFTER_GROUP_HELPER
}

HelperTriggerType getHelperTriggerType(final String value) {
  return HelperTriggerType.values.firstWhere((element) => element.toString().split('.')[1] == value);
}

String helperTriggerTypeToString(final HelperTriggerType helperTriggerType) {
  return helperTriggerType.toString().split('.')[1];
}

String getHelperTriggerTypeDescription(final HelperTriggerType helperTriggerType) {
  String description;
  switch (helperTriggerType) {
    case HelperTriggerType.ON_SCREEN_VISIT:
      description = 'On screen visit';
      break;
    case HelperTriggerType.AFTER_GROUP_HELPER:
      description = 'After helper';
      break;
    default:
  }
  return description;
}
