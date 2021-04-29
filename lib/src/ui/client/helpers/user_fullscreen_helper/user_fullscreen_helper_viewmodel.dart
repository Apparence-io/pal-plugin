import 'package:mvvm_builder/mvvm_builder.dart';

class UserFullScreenHelperModel extends MVVMModel {
  double? helperOpacity;
  bool? mediaAnimation;
  bool? titleAnimation;
  bool? feedbackAnimation;
  bool? isReversedAnimations;

  UserFullScreenHelperModel({
    this.helperOpacity,
    this.mediaAnimation,
    this.titleAnimation,
    this.feedbackAnimation,
    this.isReversedAnimations,
  });
}