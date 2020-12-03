import 'package:flutter/material.dart';
import 'package:pal/src/pal_notifications.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPageArguments {

  final GlobalKey<NavigatorState> hostedAppNavigatorKey;

  final String pageId;

  final String helperMinVersion;

  final String helperMaxVersion;

  final bool isOnEditMode;

  HelperEditorPageArguments(
    this.hostedAppNavigatorKey,
    this.pageId, {
    this.helperMinVersion,
    this.helperMaxVersion,
    this.isOnEditMode = false,
  });
}


