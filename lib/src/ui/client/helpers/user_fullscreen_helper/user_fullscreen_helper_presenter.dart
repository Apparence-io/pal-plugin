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
    startAnimations();
  }

  startAnimations() async {
    // Fullscreen background opacity animation
    await Future.delayed(Duration(milliseconds: 1000), () {
      this.viewModel.helperOpacity = 1;
      this.refreshView();
    });
  }
}
