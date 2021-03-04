import 'package:flutter/material.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

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

  Future closeEditor(bool showList, bool showBubble) async {
    Overlayed.removeOverlay(context, OverlayKeys.EDITOR_OVERLAY_KEY);
    if (showBubble) palEditModeStateService.showBubble(context, showBubble);
    if (showList) palEditModeStateService.showHelpersList(context);
  }
}
