enum HelperTheme {
  BLACK,
}

HelperTheme getHelperTheme(final String value) {
  return HelperTheme.values.firstWhere((element) => element.toString().split('.')[1] == value);
}

String helperThemeToString(final HelperTheme helperTheme) {
  return helperTheme.toString().split('.')[1];
}
