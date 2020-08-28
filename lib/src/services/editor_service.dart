import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper_widget.dart';

abstract class EditorService {
  factory EditorService.build() => _EditorService();

  CreateHelperFullScreenEntity saveFullscreenHelper(
    String pageId, {
    @required String name,
    @required HelperTriggerType triggerType,
    @required int priority,
    @required int versionMinId,
    int versionMaxId,
    @required FullscreenHelperNotifier fullscreenHelperNotifier,
  });
}

class _EditorService implements EditorService {
  _EditorService();

  @override
  CreateHelperFullScreenEntity saveFullscreenHelper(
    String pageId, {
    @required String name,
    @required HelperTriggerType triggerType,
    @required int priority,
    @required int versionMinId,
    int versionMaxId,
    @required FullscreenHelperNotifier fullscreenHelperNotifier,
  }) {
    CreateHelperFullScreenEntity fullScreenEntity =
        CreateHelperFullScreenEntity(
      name: name,
      triggerType: triggerType,
      priority: priority,
      versionMaxId: versionMaxId,
      versionMinId: versionMinId,
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
