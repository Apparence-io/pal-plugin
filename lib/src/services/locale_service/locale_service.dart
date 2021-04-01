import 'package:flutter/material.dart';

class LocaleService {
  final GlobalKey<NavigatorState> hostedKey;
  final Locale defaultLocale;

  LocaleService({this.hostedKey, this.defaultLocale});

  Locale get locale =>
      defaultLocale ?? Localizations.localeOf(hostedKey.currentContext);

  String get languageCode => locale.languageCode;
}
