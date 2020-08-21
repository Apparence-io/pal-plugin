enum HelperType {
  HELPER_FULL_SCREEN
}

HelperType getTriggerHelperType(final String value) {
  return HelperType.values.firstWhere((element) => element.toString().split(".")[1] == value);
}

String helperTypeToString(final HelperType helperType) {
  return helperType.toString().split(".")[1];
}
