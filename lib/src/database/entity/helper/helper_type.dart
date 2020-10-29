enum HelperType {
  HELPER_FULL_SCREEN,
  SIMPLE_HELPER,
  ANCHORED_OVERLAYED_HELPER,
  UPDATE_HELPER,
}

HelperType getHelperType(final String value) {
  return HelperType.values
      .firstWhere((element) => element.toString().split('.')[1] == value);
}

String helperTypeToString(final HelperType helperType) {
  return helperType.toString().split('.')[1];
}

String getHelperTypeDescription(final HelperType helperType) {
  String description;
  switch (helperType) {
    case HelperType.HELPER_FULL_SCREEN:
      description = 'Fullscreen';
      break;
    case HelperType.UPDATE_HELPER:
      description = 'Update overlay';
      break;
    case HelperType.SIMPLE_HELPER:
      description = 'Overlayed bottom';
      break;
    default:
  }
  return description;
}
