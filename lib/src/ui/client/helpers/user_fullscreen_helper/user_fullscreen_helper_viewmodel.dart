import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

class UserFullScreenHelperModel extends MVVMModel {
  double? helperOpacity;
  bool? animate, animatePosition;
  bool? isReversedAnimations;
  GroupViewModel group;

  UserFullScreenHelperModel({
    this.helperOpacity,
    this.animate,
    this.isReversedAnimations,
    required this.group
  });
}