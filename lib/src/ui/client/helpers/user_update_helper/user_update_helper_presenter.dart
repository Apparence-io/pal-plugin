import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/user_update_helper.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/user_update_helper_viewmodel.dart';

class UserUpdateHelperPresenter
    extends Presenter<UserUpdateHelperModel, UserUpdateHelperView> {
  final PackageVersionReader packageVersionReader;

  UserUpdateHelperPresenter(
    UserUpdateHelperView viewInterface,
    this.packageVersionReader,
  ) : super(UserUpdateHelperModel(), viewInterface);

  @override
  onInit() {
    this.viewModel.appVersion = '--';
    this.viewModel.helperOpacity = 0;
    this.viewModel.changelogCascadeAnimation = false;
    this.viewModel.progressBarAnimation = false;
    this.viewModel.imageAnimation = false;
    this.viewModel.titleAnimation = false;
    this.viewModel.showThanksButton = false;
    this.viewModel.isReversedAnimations = false;

    readAppInfo();
    startAnimations();
  }

  readAppInfo() async {
    await this.packageVersionReader.init();
    this.viewModel.appVersion = this.packageVersionReader.version;
  }

  startAnimations() async {
    this.viewModel.isReversedAnimations = false;

    // Fullscreen background opacity animation
    await Future.delayed(Duration(milliseconds: 1000), () {
      this.viewModel.helperOpacity = 1;
      this.refreshView();
    });

    await Future.delayed(Duration(milliseconds: 0), () {
      this.viewModel.imageAnimation = true;
      this.viewModel.titleAnimation = true;
      this.refreshAnimations();
    });

    // Changelog animation & progress bar
    await Future.delayed(Duration(milliseconds: 400), () {
      this.viewModel.changelogCascadeAnimation = true;
      this.viewModel.progressBarAnimation = true;
      this.refreshAnimations();
    });
  }

  Future reverseAnimations() async {
    this.viewModel.isReversedAnimations = true;

    await Future.delayed(Duration(milliseconds: 0), () {
      this.viewModel.changelogCascadeAnimation = true;
      this.refreshAnimations();
    });

    await Future.delayed(Duration(milliseconds: 800), () {
      this.viewModel.titleAnimation = true;
      this.refreshAnimations();
    });

    await Future.delayed(Duration(milliseconds: 200), () {
      this.viewModel.imageAnimation = true;
      this.refreshAnimations();
    });

    await Future.delayed(Duration(milliseconds: 500), () {
      this.viewModel.helperOpacity = 0;
      this.refreshView();
    });

    await Future.delayed(Duration(milliseconds: 500));
  }

  onCascadeAnimationEnd() {
    this.viewModel.changelogCascadeAnimation = false;
  }

  onProgressBarAnimationEnd() {
    this.viewModel.progressBarAnimation = false;
    this.viewModel.showThanksButton = true;
    this.refreshView();
  }

  onTitleAnimationEnd() {
    this.viewModel.titleAnimation = false;
  }

  onImageAnimationEnd() {
    this.viewModel.imageAnimation = false;
  }

  onThanksButtonCallback() async {
    await this.reverseAnimations();
    this.viewInterface.onThanksButtonCallback();
  }
}
