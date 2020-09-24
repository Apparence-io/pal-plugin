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

    readAppInfo();
    startAnimations();
  }

  readAppInfo() async {
    await this.packageVersionReader.init();
    this.viewModel.appVersion = this.packageVersionReader.version;
  }

  startAnimations() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      this.viewModel.helperOpacity = 1;
      this.refreshView();
    });
    await Future.delayed(Duration(milliseconds: 400), () {
      this.viewModel.changelogCascadeAnimation = true;
      this.refreshAnimations();
    });
  }

  onCascadeAnimationEnd() {
    this.viewModel.changelogCascadeAnimation = true;
  }
}
