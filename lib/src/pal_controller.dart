import 'package:flutter/foundation.dart';

class PalController {
  static final PalController _singleton = new PalController._internal();
  static PalController get instance => _singleton;

  PalController._internal();
  
  ValueNotifier<String> routeName = ValueNotifier(null);
}
