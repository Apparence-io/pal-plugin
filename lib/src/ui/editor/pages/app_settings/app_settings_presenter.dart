import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_viewmodel.dart';

class AppSettingsPresenter
    extends Presenter<AppSettingsModel, AppSettingsView> {
  final PackageVersionReader packageVersionReader;

  AppSettingsPresenter(
    AppSettingsView viewInterface, {
    @required this.packageVersionReader,
  }) : super(AppSettingsModel(), viewInterface);

  @override
  Future onInit() async {
    this.viewModel.headerKey = GlobalKey();
    this.viewModel.appIconAnimation = false;

    readAppInfo();
    startAnimation();

    WidgetsBinding.instance.addPostFrameCallback(afterLayout);
  }

  afterLayout(Duration duration) {
    RenderBox _headerRenderBox =
        this.viewModel.headerKey.currentContext.findRenderObject();
    this.viewModel.headerSize = _headerRenderBox.size;
    this.refreshView();
  }

  startAnimation() async {
    await Future.delayed(Duration(milliseconds: 350), () {
      this.viewModel.appIconAnimation = true;
      this.refreshAnimations();
    });
  }

  onAppIconAnimationEnd() {
    this.viewModel.appIconAnimation = false;
  }

  readAppInfo() async {
    await this.packageVersionReader.init();
    this.viewModel.appVersion = this.packageVersionReader.version;
  }

  refreshAppIcon() {
    print('TEST');
  }
}
