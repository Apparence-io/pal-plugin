import 'package:mvvm_builder/mvvm_builder.dart';

class UserFullScreenHelperModel extends MVVMModel {
  double? helperOpacity;
  bool? animate, animatePosition;
  bool? isReversedAnimations;

  UserFullScreenHelperModel({
    this.helperOpacity,
    this.animate,
    this.isReversedAnimations,
  });
}