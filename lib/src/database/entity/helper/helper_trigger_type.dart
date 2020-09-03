enum HelperTriggerType {
  ON_SCREEN_VISIT,
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
    default:
  }
  return description;
}
