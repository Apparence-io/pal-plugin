import 'dart:io';

class PalUtils {
  static bool isRunningInTestEnv() =>
      Platform.environment.containsKey('FLUTTER_TEST');
}