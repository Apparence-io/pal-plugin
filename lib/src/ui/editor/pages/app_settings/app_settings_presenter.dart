import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/project/app_icon_grabber_delegate.dart';
import 'package:pal/src/services/editor/project/project_editor_service.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/ui/editor/pages/app_settings/app_settings.dart';
import 'package:pal/src/ui/editor/pages/app_settings/app_settings_viewmodel.dart';

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
    this.viewModel.isLoadingAppInfo = false;
    await this.getAppIcon();

    this.readAppInfo();
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
    this.viewModel.isLoadingAppInfo = true;
    this.refreshView();

    await this.packageVersionReader.init();
    this.viewModel.appVersion = this.packageVersionReader.version;
    this.viewModel.appName = this.packageVersionReader.appName;

    this.viewModel.isLoadingAppInfo = false;
    this.refreshView();
  }

  refreshAppIcon() async {
    this.viewModel.isSendingAppIcon = true;
    this.refreshView();

    Uint8List appIcon = await this.appIconGrabberDelegate.getClientAppIcon();
    if (this.viewModel.appIconId == null) {
      //Create app icon
      this._createAppIcon(appIcon);
    } else {
      // update app icon
      this._updateAppIcon(appIcon, this.viewModel.appIconId);
    }
  }

  void _createAppIcon(Uint8List appIcon) {
    this.projectEditorService.sendAppIcon(appIcon, "png").then((appIcon) {
      this.viewModel.appIconId = appIcon.id;
      this.viewModel.appIconUrl = appIcon.url;
      this.viewModel.isSendingAppIcon = false;
      this.refreshView();
      this.viewInterface.showMessage('App icon updated successfully', true);
    }).catchError((onError) {
      this.viewModel.isSendingAppIcon = false;
      this.refreshView();
      this.viewInterface.showMessage('error while saving app Icon', false);
    });
  }

  void _updateAppIcon(Uint8List appIcon, String appIconId) {
    this
        .projectEditorService
        .updateAppIcon(appIconId, appIcon, "png")
        .then((appIcon) {
      this.viewModel.appIconId = appIcon.id;
      this.viewModel.appIconUrl = appIcon.url;
      this.viewModel.isSendingAppIcon = false;
      this.refreshView();
      this.viewInterface.showMessage('App icon updated successfully', true);
    }).catchError((onError) {
      this.viewModel.isSendingAppIcon = false;
      this.refreshView();
      this.viewInterface.showMessage('error while saving app Icon', false);
    });
  }

  Future getAppIcon() {
    return this.projectEditorService.getAppIcon().then((appIcon) {
        this.viewModel.appIconId = appIcon.id;
        this.viewModel.appIconUrl = appIcon.url;
    });
  }
}
