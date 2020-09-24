import 'package:mvvm_builder/mvvm_builder.dart';

class UserUpdateHelperModel extends MVVMModel {
  double helperOpacity;
  String appVersion;
  bool changelogCascadeAnimation;
  
  UserUpdateHelperModel({
    this.helperOpacity,
    this.appVersion,
    this.changelogCascadeAnimation,
  });
}