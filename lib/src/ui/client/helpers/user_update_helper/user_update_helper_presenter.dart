import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/user_update_helper.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/user_update_helper_viewmodel.dart';

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

    readAppInfo();
    startAnimations();
  }

  readAppInfo() async {
    await this.packageVersionReader.init();
    this.viewModel.appVersion = this.packageVersionReader.version;
  }

  startAnimations() async {
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
}
