import 'dart:io';

import 'package:flutter/foundation.dart';

class PalUtils {
  static bool isRunningInTestEnv() =>
      !kIsWeb ? Platform.environment.containsKey('FLUTTER_TEST') : false;
}