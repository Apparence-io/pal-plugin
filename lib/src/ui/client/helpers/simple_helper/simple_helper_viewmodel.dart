import 'dart:async';

import 'package:mvvm_builder/mvvm_builder.dart';

class SimpleHelperModel extends MVVMModel {
  late bool thumbAnimation;
  late bool boxTransitionAnimation;
  late bool shakeAnimation;
  Timer? shakeAnimationTimer;
}