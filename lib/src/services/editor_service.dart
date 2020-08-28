import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper_widget.dart';
import 'package:palplugin/src/ui/editor/pages/editor/editor_viewmodel.dart';

abstract class EditorService {
  factory EditorService.build() => _EditorService();

  CreateHelperFullScreenEntity saveFullscreenHelper(
    String pageId, {
    @required BasicHelper basicHelper,
    @required FullscreenHelperNotifier fullscreenHelperNotifier,
  });
}

class _EditorService implements EditorService {
  _EditorService();

  @override
  CreateHelperFullScreenEntity saveFullscreenHelper(
    String pageId, {
    @required BasicHelper basicHelper,
    @required FullscreenHelperNotifier fullscreenHelperNotifier,
  }) {
    CreateHelperFullScreenEntity fullScreenEntity =
        CreateHelperFullScreenEntity(
      name: basicHelper.name,
      triggerType: basicHelper.triggerType,
      priority: basicHelper.priority,
      versionMaxId: basicHelper.versionMaxId,
      versionMinId: basicHelper.versionMinId,
      title: fullscreenHelperNotifier.title?.value,
      fontColor: _colorToHex(fullscreenHelperNotifier.fontColor?.value),
      backgroundColor:
          _colorToHex(fullscreenHelperNotifier.backgroundColor?.value),
      borderColor: _colorToHex(fullscreenHelperNotifier.borderColor?.value),
      languageId: fullscreenHelperNotifier.languageId?.value,
    );
    return fullScreenEntity;
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2, 8)}';
  }
}
