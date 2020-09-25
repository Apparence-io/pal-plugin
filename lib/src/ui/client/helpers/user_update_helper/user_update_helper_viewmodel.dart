import 'package:mvvm_builder/mvvm_builder.dart';

class UserUpdateHelperModel extends MVVMModel {
  double helperOpacity;
  String appVersion;
  bool changelogCascadeAnimation;
  bool progressBarAnimation;
  bool showThanksButton;
  
  UserUpdateHelperModel({
    this.helperOpacity,
    this.appVersion,
    this.changelogCascadeAnimation,
    this.progressBarAnimation,
    this.showThanksButton,
  });
}