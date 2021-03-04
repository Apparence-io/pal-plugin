import 'package:hive/hive.dart';

part 'helper_trigger_type.g.dart';

@HiveType(typeId: 11)
enum HelperTriggerType {
  @HiveField(0)
  ON_SCREEN_VISIT,

  @HiveField(1)
  ON_NEW_UPDATE,
}

HelperTriggerType getHelperTriggerType(final String value) =>
    HelperTriggerType.values
        .firstWhere((element) => element.toString().split('.')[1] == value);

String helperTriggerTypeToString(final HelperTriggerType helperTriggerType) =>
    helperTriggerType.toString().split('.')[1];

String getHelperTriggerTypeDescription(
    final HelperTriggerType helperTriggerType) {
  String description;
  switch (helperTriggerType) {
    case HelperTriggerType.ON_SCREEN_VISIT:
      description = 'On screen visit';
      break;
    case HelperTriggerType.ON_NEW_UPDATE:
      description = 'On new update';
      break;
  }
  return description;
}
