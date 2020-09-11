enum HelperType {
  HELPER_FULL_SCREEN,
  SIMPLE_HELPER,
  ANCHORED_OVERLAYED_HELPER,
}

HelperType getHelperType(final String value) {
  return HelperType.values.firstWhere((element) => element.toString().split('.')[1] == value);
}

String helperTypeToString(final HelperType helperType) {
  return helperType.toString().split('.')[1];
}
