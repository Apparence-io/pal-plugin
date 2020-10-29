import 'dart:async';

import 'package:mvvm_builder/mvvm_builder.dart';

class SimpleHelperModel extends MVVMModel {
  bool thumbAnimation;
  bool boxTransitionAnimation;
  bool shakeAnimation;
  Timer shakeAnimationTimer;
}