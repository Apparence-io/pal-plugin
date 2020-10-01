import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/services/editor/project/app_icon_grabber_delegate.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_viewmodel.dart';

class AppSettingsPresenter
    extends Presenter<AppSettingsModel, AppSettingsView> {
  final AppIconGrabberDelegate appIconGrabberDelegate;

  AppSettingsPresenter(
    AppSettingsView viewInterface, {
    @required this.appIconGrabberDelegate,
  }) : super(AppSettingsModel(), viewInterface);

  @override
  Future onInit() async {
    this.viewModel.headerKey = GlobalKey();
    this.viewModel.appIcon =
        await this.appIconGrabberDelegate.getClientAppIcon();
    getSizeAndPosition();
  }

  getSizeAndPosition() {
    RenderBox _headerRenderBox = this.viewModel.headerKey.currentContext.findRenderObject();
    this.viewModel.headerSize = _headerRenderBox.size;
    this.refreshView();
  }

  refreshAppIcon() {
    print('TEST');
  }
}
