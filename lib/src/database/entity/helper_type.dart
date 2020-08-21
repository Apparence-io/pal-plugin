enum HelperType {
  HELPER_ON_SCREEN_VISIT
}

HelperType getTriggerHelperType(final String value) {
  return HelperType.values.firstWhere((element) => element.toString().split(".")[1] == value);
}
