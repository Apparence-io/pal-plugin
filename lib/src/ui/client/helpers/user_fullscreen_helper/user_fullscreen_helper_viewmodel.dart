import 'package:mvvm_builder/mvvm_builder.dart';

class UserFullScreenHelperModel extends MVVMModel {
  double helperOpacity;
  bool mediaAnimation;
  bool titleAnimation;
  bool feedbackAnimation;

  UserFullScreenHelperModel({
    this.helperOpacity,
    this.mediaAnimation,
    this.titleAnimation,
    this.feedbackAnimation,
  });
}