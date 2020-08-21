enum TriggerHelper {
  HELPER_ON_SCREEN_VISIT
}

TriggerHelper getTriggerHelperType(final String value) {
  return TriggerHelper.values.firstWhere((element) => element.toString().split(".")[1] == value);
}
