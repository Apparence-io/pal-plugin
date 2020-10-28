import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/extensions/color_extension.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_models.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/simple_helper.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/user_update_helper.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';

import 'helpers/simple_helper/widget/simple_helper_layout.dart';

class HelperFactory {
  static Widget build(final HelperEntity helper,
      {final Function(bool positiveFeedBack) onTrigger}) {
    switch (helper.type) {
      case HelperType.HELPER_FULL_SCREEN:
        return _createHelperFullScreen(helper, onTrigger);
      case HelperType.SIMPLE_HELPER:
        return _createSimpleHelper(helper, onTrigger);
      case HelperType.UPDATE_HELPER:
        return _createUpdateHelper(helper, onTrigger);
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        break;
    }
    return null;
  }

  static Widget _createHelperFullScreen(
    final HelperEntity helper,
    final Function onTrigger,
  ) {
    return UserFullScreenHelperPage(
      titleLabel: _parseTextLabel(
        FullscreenHelperKeys.TITLE_KEY,
        helper.helperTexts,
      ),
      mediaUrl: _parseImageUrl(
        FullscreenHelperKeys.IMAGE_KEY,
        helper.helperImages,
      ),
      backgroundColor: _parseBoxBackground(
        FullscreenHelperKeys.BACKGROUND_KEY,
        helper.helperBoxes,
      ),
      positivLabel: _parseTextLabel(
        FullscreenHelperKeys.POSITIV_KEY,
        helper.helperTexts,
      ),
      negativLabel: _parseTextLabel(
        FullscreenHelperKeys.NEGATIV_KEY,
        helper.helperTexts,
      ),
      onPositivButtonTap: () => onTrigger(true),
      onNegativButtonTap: () => onTrigger(false),
    );
  }

  static CustomLabel _parseTextLabel(
    final String key,
    final List<HelperTextEntity> helperTexts,
  ) {
    for (HelperTextEntity helperText in helperTexts) {
      if (key == helperText?.key) {
        return CustomLabel(
          text: helperText?.value,
          fontColor: HexColor.fromHex(helperText?.fontColor),
          fontSize: helperText?.fontSize?.toDouble(),
          fontFamily: helperText?.fontFamily,
          fontWeight: FontWeightMapper.toFontWeight(helperText?.fontWeight),
        );
      }
    }
    return null;
  }

  static String _parseImageUrl(
    final String key,
    final List<HelperImageEntity> helperImages,
  ) {
    for (HelperImageEntity helperImage in helperImages) {
      if (key == helperImage?.key) {
        return helperImage?.url;
      }
    }
    return null;
  }

  static Color _parseBoxBackground(
    final String key,
    final List<HelperBoxEntity> helperBoxes,
  ) {
    for (HelperBoxEntity helperBox in helperBoxes) {
      if (key == helperBox?.key) {
        return HexColor.fromHex(helperBox?.backgroundColor);
      }
    }
    return null;
  }

  static Color _parseBorder(
    final String key,
    final List<HelperBorderEntity> helperBorders,
  ) {
    for (HelperBorderEntity helperBorder in helperBorders) {
      if (key == helperBorder?.key) {
        return HexColor.fromHex(helperBorder?.color);
      }
    }
    return null;
  }

  static List<CustomLabel> _parseChangeLogLabel(
    final String key,
    final List<HelperTextEntity> helperTexts,
  ) {
    List<CustomLabel> customLabels = [];
    for (HelperTextEntity helperText in helperTexts) {
      if (helperText.key.startsWith(key)) {
        customLabels.add(CustomLabel(
          text: helperText?.value,
          fontColor: HexColor.fromHex(helperText?.fontColor),
          fontSize: helperText?.fontSize?.toDouble(),
          fontFamily: helperText?.fontFamily,
          fontWeight: FontWeightMapper.toFontWeight(helperText?.fontWeight),
        ));
      }
    }
    return customLabels;
  }

  static Widget _createSimpleHelper(
      final HelperEntity helper, final Function onTrigger) {
    return SimpleHelperLayout(
      toaster: SimpleHelperPage(
        descriptionLabel: _parseTextLabel(
          SimpleHelperKeys.CONTENT_KEY,
          helper.helperTexts,
        ),
        backgroundColor: _parseBoxBackground(SimpleHelperKeys.BACKGROUND_KEY,
            helper.helperBoxes),
      ),
      onDismissed: (res) => onTrigger(res == DismissDirection.startToEnd),
    );
  }

  static Widget _createUpdateHelper(
      final HelperEntity helper, final Function onTrigger) {
    return UserUpdateHelperPage(
      onTrigger: () {
        onTrigger(true);
      },
      backgroundColor: _parseBoxBackground(
        UpdatescreenHelperKeys.BACKGROUND_KEY,
        helper.helperBoxes,
      ),
      thanksButtonLabel: _parseTextLabel(
        UpdatescreenHelperKeys.POSITIV_KEY,
        helper.helperTexts,
      ),
      titleLabel: _parseTextLabel(
        UpdatescreenHelperKeys.TITLE_KEY,
        helper.helperTexts,
      ),
      changelogLabels: _parseChangeLogLabel(
        UpdatescreenHelperKeys.LINES_KEY,
        helper.helperTexts,
      ),
      mediaUrl: _parseImageUrl(
        UpdatescreenHelperKeys.IMAGE_KEY,
        helper.helperImages,
      ),
    );
  }
}
