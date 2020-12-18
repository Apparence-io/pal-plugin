import 'package:flutter/material.dart';
import 'package:pal/src/pal_notifications.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';
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


mixin EditorNavigationMixin {

  BuildContext context;
  PalEditModeStateService palEditModeStateService;

  Future closeEditor() async {
    Overlayed.removeOverlay(context, OverlayKeys.EDITOR_OVERLAY_KEY);
    palEditModeStateService.showBubble(context, true);
    palEditModeStateService.showHelpersList(context);
  }
}

