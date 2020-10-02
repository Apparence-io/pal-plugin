import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/services/editor/project/app_icon_grabber_delegate.dart';
import 'package:palplugin/src/services/editor/project/project_editor_service.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_viewmodel.dart';

class AppSettingsPresenter
    extends Presenter<AppSettingsModel, AppSettingsView> {
  final PackageVersionReader packageVersionReader;
  final AppIconGrabberDelegate appIconGrabberDelegate;
  final ProjectEditorService projectEditorService;

  AppSettingsPresenter(
    AppSettingsView viewInterface, {
    @required this.packageVersionReader,
    @required this.projectEditorService,
    @required this.appIconGrabberDelegate,
  }) : super(AppSettingsModel(), viewInterface);

  @override
  Future onInit() async {
    this.viewModel.appIconAnimation = false;
    this.viewModel.isSendingAppIcon = false;

    readAppInfo();
    startAnimation();

    WidgetsBinding.instance.addPostFrameCallback(afterLayout);
  }

  afterLayout(Duration duration) {
    this.viewModel.headerSize = this.viewInterface.getHeaderSize();
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

  refreshAppIcon() async {
    this.viewModel.isSendingAppIcon = true;
    this.refreshView();

    Uint8List appIcon = await this.appIconGrabberDelegate.getClientAppIcon();
    await this.projectEditorService.sendAppIcon(appIcon);
    
    this.viewModel.isSendingAppIcon = false;
    this.refreshView();

    this.viewInterface.showMessage('App icon updated successfully', true);
  }
}
