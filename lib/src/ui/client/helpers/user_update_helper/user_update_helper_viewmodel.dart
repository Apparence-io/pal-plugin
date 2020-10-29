import 'package:mvvm_builder/mvvm_builder.dart';

class UserUpdateHelperModel extends MVVMModel {
  double helperOpacity;
  String appVersion;
  bool changelogCascadeAnimation;
  bool progressBarAnimation;
  bool titleAnimation;
  bool imageAnimation;
  bool showThanksButton;
  bool isReversedAnimations;
  
  UserUpdateHelperModel({
    this.helperOpacity,
    this.appVersion,
    this.changelogCascadeAnimation,
    this.progressBarAnimation,
    this.titleAnimation,
    this.imageAnimation,
    this.showThanksButton,
    this.isReversedAnimations,
  });
}