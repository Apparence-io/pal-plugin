import 'package:mvvm_builder/mvvm_builder.dart';

import 'user_fullscreen_helper.dart';
import 'user_fullscreen_helper_viewmodel.dart';

class UserFullScreenHelperPresenter extends Presenter<UserFullScreenHelperModel, UserFullScreenHelperView> {

  UserFullScreenHelperPresenter(
    UserFullScreenHelperView viewInterface,
  ) : super(UserFullScreenHelperModel(), viewInterface) {
    this.viewModel.helperOpacity = 0;
    this.viewModel.animate = false;
    this.viewModel.animatePosition = false;
    this.viewModel.isReversedAnimations = false;
  }

  @override
  void onInit() {
    startAnimations();
  }

  startAnimations() async {
    this.viewModel.isReversedAnimations = false;
    // Fullscreen background opacity animation
    await Future.delayed(Duration(milliseconds: 100), () {
      this.viewModel.helperOpacity = 1;
      this.viewModel.animate = true;
      this.refreshView();
      this.refreshAnimations();
    });
  }

  reverseAnimations() async {
    this.viewModel.isReversedAnimations = true;
    await Future.delayed(Duration(milliseconds: 100), () {
      this.viewModel.animate = true;
      this.viewModel.animatePosition = true;
      this.refreshAnimations();
    });
    await Future.delayed(Duration(milliseconds: 1000));
  }

  onAnimationEnd() {
    this.viewModel.animate = false;
  }

  onPositivButtonCallback() async {
    await this.reverseAnimations();
    this.viewInterface.onPositivButtonCallback();
  }

  onNegativButtonCallback() async {
    await this.reverseAnimations();
    this.viewInterface.onNegativButtonCallback();
  }
}
