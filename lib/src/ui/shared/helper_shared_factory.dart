import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/extensions/color_extension.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

///-------------------------------
/// KEYS to link data to right element
///-------------------------------
class SimpleHelperKeys {
  static const CONTENT_KEY = "CONTENT";
  static const BACKGROUND_KEY = "BACKGROUND_KEY"; // mandatory
}

class FullscreenHelperKeys {
  static const TITLE_KEY = "TITLE_KEY"; // mandatory
  static const DESCRIPTION_KEY = "DESCRIPTION_KEY";
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

class AnchoredscreenHelperKeys {
  static const TITLE_KEY = "TITLE_KEY"; // mandatory
  static const DESCRIPTION_KEY = "DESCRIPTION_KEY"; // mandatory
  static const POSITIV_KEY = "POSITIV_KEY"; // not mandatory
  static const NEGATIV_KEY = "NEGATIV_KEY"; // not mandatory
  static const BACKGROUND_KEY = "BACKGROUND_KEY"; // mandatory
}

class HelperSharedFactory {
  static HelperTextViewModel? parseTextLabel(
    final String key,
    final List<HelperTextEntity> helperTexts,
  ) {
    for (HelperTextEntity helperText in helperTexts) {
      if (key == helperText.key) {
        return HelperTextViewModel(
          id: helperText.id,
          text: helperText.value,
          fontColor: HexColor.fromHex(helperText.fontColor!),
          fontSize: helperText.fontSize?.toDouble(),
          fontFamily: helperText.fontFamily,
          fontWeight: FontWeightMapper.toFontWeight(helperText.fontWeight),
        );
      }
    }
    return null;
  }

  static HelperButtonViewModel? parseButtonLabel(
    final String key,
    final List<HelperTextEntity> helperTexts,
    {HelperButtonStyle? buttonStyle}
  ) {
    for (HelperTextEntity helperText in helperTexts) {
      if (key == helperText.key) {
        return HelperButtonViewModel(
          id: helperText.id,
          buttonStyle: buttonStyle,
          text: helperText.value,
          fontColor: HexColor.fromHex(helperText.fontColor!),
          fontSize: helperText.fontSize?.toDouble(),
          fontFamily: helperText.fontFamily,
          fontWeight: FontWeightMapper.toFontWeight(helperText.fontWeight),
        );
      }
    }
    return null;
  }

  static HelperImageViewModel? parseImageUrl(
    final String key,
    final List<HelperImageEntity>? helperImages,
  ) {
    if (helperImages == null || helperImages.length == 0) {
      return null;
    }
    for (HelperImageEntity helperImage in helperImages) {
      if (key == helperImage.key) {
        return HelperImageViewModel(
          id: helperImage.id,
          url: helperImage.url,
        );
      }
    }
    return null;
  }

  static HelperBoxViewModel? parseBoxBackground(
    final String key,
    final List<HelperBoxEntity> helperBoxes,
  ) {
    for (HelperBoxEntity helperBox in helperBoxes) {
      if (key == helperBox.key) {
        return HelperBoxViewModel(
            id: helperBox.id,
            backgroundColor: HexColor.fromHex(helperBox.backgroundColor!));
      }
    }
    return null;
  }

  static HelperBorderViewModel? parseBorder(
    final String key,
    final List<HelperBorderEntity> helperBorders,
  ) {
    for (HelperBorderEntity helperBorder in helperBorders) {
      if (key == helperBorder.key) {
        return HelperBorderViewModel(
          id: helperBorder.id,
          style: helperBorder.style,
          color: HexColor.fromHex(helperBorder.color!),
          width: helperBorder.width,
        );
      }
    }
    return null;
  }

  static List<HelperTextViewModel> parseTextsLabel(
    final String key,
    final List<HelperTextEntity> helperTexts,
  ) {
    // TODO: Reorganize array from back ?
    List<HelperTextViewModel> customLabels = [];
    for (HelperTextEntity helperText in helperTexts) {
      if (helperText.key!.startsWith(key)) {
        customLabels.add(
          HelperTextViewModel(
            id: helperText.id ?? helperTexts.indexOf(helperText),
            text: helperText.value,
            fontColor: HexColor.fromHex(helperText.fontColor!),
            fontSize: helperText.fontSize?.toDouble(),
            fontFamily: helperText.fontFamily,
            fontWeight: FontWeightMapper.toFontWeight(helperText.fontWeight),
          ),
        );
      }
    }
    return customLabels;
  }

  // ************ HELPER PREVIEW UTILS

  static HelperTextViewModel parseTextNotifier(EditableTextFormData notifier) {
    return HelperTextViewModel(
      text: notifier.text,
      fontColor: notifier.fontColor,
      fontSize: notifier.fontSize?.toDouble(),
      fontWeight: FontWeightMapper.toFontWeight(notifier.fontWeight),
      fontFamily: notifier.fontFamily,
    );
  }

  static HelperButtonViewModel parseButtonNotifier(
      EditableButtonFormData notifier) {
    return HelperButtonViewModel(
      text: notifier.text,
      fontColor: notifier.fontColor,
      fontSize: notifier.fontSize?.toDouble(),
      fontWeight: FontWeightMapper.toFontWeight(notifier.fontWeight),
      fontFamily: notifier.fontFamily,
    );
  }

  static HelperBoxViewModel parseBoxNotifier(EditableBoxFormData notifier) {
    return HelperBoxViewModel(
      backgroundColor: notifier.backgroundColor,
    );
  }

  static HelperImageViewModel parseMediaNotifier(
      EditableMediaFormData notifier) {
    return HelperImageViewModel(
      url: notifier.url,
    );
  }
}
