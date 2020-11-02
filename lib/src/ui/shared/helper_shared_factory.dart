import 'dart:ui';

import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/extensions/color_extension.dart';
import 'package:palplugin/src/ui/shared/helper_shared_viewmodels.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';

///-------------------------------
/// KEYS to link data to right element
///-------------------------------
class SimpleHelperKeys {
  static const CONTENT_KEY = "CONTENT";
  static const BACKGROUND_KEY = "BACKGROUND_KEY"; // mandatory
}

class FullscreenHelperKeys {
  static const TITLE_KEY = "TITLE_KEY"; // mandatory
  static const DESCRIPTION_KEY = "DESCRIPTION_KEY"; //TODO for next release
  static const POSITIV_KEY = "POSITIV_KEY"; // not mandatory
  static const NEGATIV_KEY = "NEGATIV_KEY"; // not mandatory
  static const IMAGE_KEY = "IMAGE_KEY"; // not mandatory
  static const BACKGROUND_KEY = "BACKGROUND_KEY"; // mandatory
}

class UpdatescreenHelperKeys {
  static const TITLE_KEY = "TITLE_KEY"; // mandatory
  static const LINES_KEY = "LINES_KEY"; //first mandatory
  static const POSITIV_KEY = "POSITIV_KEY"; // not mandatory
  static const IMAGE_KEY = "IMAGE_KEY"; // not mandatory
  static const BACKGROUND_KEY = "BACKGROUND_KEY"; // mandatory
}

class HelperSharedFactory {
  static HelperTextViewModel parseTextLabel(
    final String key,
    final List<HelperTextEntity> helperTexts,
  ) {
    for (HelperTextEntity helperText in helperTexts) {
      if (key == helperText?.key) {
        return HelperTextViewModel(
          id: helperText?.id,
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

  static String parseImageUrl(
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

  static Color parseBoxBackground(
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

  static Color parseBorder(
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

  static List<HelperTextViewModel> parseTextsLabel(
    final String key,
    final List<HelperTextEntity> helperTexts,
  ) {
    List<HelperTextViewModel> customLabels = [];
    for (HelperTextEntity helperText in helperTexts) {
      if (helperText.key.startsWith(key)) {
        customLabels.add(
          HelperTextViewModel(
            id: helperText?.id,
            text: helperText?.value,
            fontColor: HexColor.fromHex(helperText?.fontColor),
            fontSize: helperText?.fontSize?.toDouble(),
            fontFamily: helperText?.fontFamily,
            fontWeight: FontWeightMapper.toFontWeight(helperText?.fontWeight),
          ),
        );
      }
    }
    return customLabels;
  }
}
