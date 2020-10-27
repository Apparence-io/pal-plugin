import 'package:mvvm_builder/mvvm_builder.dart';

import 'user_fullscreen_helper.dart';
import 'user_fullscreen_helper_viewmodel.dart';

class UserFullScreenHelperPresenter
    extends Presenter<UserFullScreenHelperModel, UserFullScreenHelperView> {
  UserFullScreenHelperPresenter(
    UserFullScreenHelperView viewInterface,
  ) : super(UserFullScreenHelperModel(), viewInterface);

  @override
  void onInit() {
    this.viewModel.helperOpacity = 0;
    this.viewModel.feedbackAnimation = false;
    this.viewModel.mediaAnimation = false;
    this.viewModel.titleAnimation = false;

    startAnimations();
  }

  startAnimations() async {
    // Fullscreen background opacity animation
    await Future.delayed(Duration(milliseconds: 1000), () {
      this.viewModel.helperOpacity = 1;
      this.refreshView();
    });

    await Future.delayed(Duration(milliseconds: 500), () {
      this.viewModel.mediaAnimation = true;
      this.refreshAnimations();
    });

    await Future.delayed(Duration(milliseconds: 200), () {
      this.viewModel.titleAnimation = true;
      this.refreshAnimations();
    });

    await Future.delayed(Duration(milliseconds: 100), () {
      this.viewModel.feedbackAnimation = true;
      this.refreshAnimations();
    });
  }

  onTitleAnimationEnd() {
    this.viewModel.titleAnimation = false;
  }

  onMediaAnimationEnd() {
    this.viewModel.mediaAnimation = false;
  }

  onFeedbackAnimationEnd() {
    this.viewModel.feedbackAnimation = false;
  }

  onPositivButtonCallback() {
    this.viewInterface.onPositivButtonCallback();
  }

  onNegativButtonCallback() {
    this.viewInterface.onNegativButtonCallback();
  }
}
