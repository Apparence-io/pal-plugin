import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';

import 'helper_editor_models.dart';

class HelperEditorAdapter {
  
  static HelperEntity parseSimpleHelper(CreateSimpleHelper args)
    => _parseConfig(args.config, HelperType.SIMPLE_HELPER)
        ..helperTexts = [_parseHelperText(SimpleHelperKeys.CONTENT_KEY, args.titleText)]
        ..helperBoxes = args.boxConfig?.color != null ? [_parseHelperBox(SimpleHelperKeys.BACKGROUND_KEY, args.boxConfig)] : [];
  
  static HelperEntity parseFullscreenHelper(CreateFullScreenHelper args)
    => _parseConfig(args.config, HelperType.HELPER_FULL_SCREEN)
      ..helperImages = args.mediaHeader?.url != null && args.mediaHeader.url.isNotEmpty ?
        [_parseHelperImage(FullscreenHelperKeys.IMAGE_KEY, args.mediaHeader)]:[]
      ..helperTexts = [
        _parseHelperText(FullscreenHelperKeys.TITLE_KEY, args.title),
        _parseHelperText(FullscreenHelperKeys.DESCRIPTION_KEY, args.description),
        _parseHelperText(FullscreenHelperKeys.POSITIV_KEY, args.positivButton),
        _parseHelperText(FullscreenHelperKeys.NEGATIV_KEY, args.negativButton),
      ]
      ..helperBoxes =  [_parseHelperBox(FullscreenHelperKeys.BACKGROUND_KEY, args.bodyBox)];

  static HelperEntity parseUpdateHelper(CreateUpdateHelper args)
    => _parseConfig(args.config, HelperType.UPDATE_HELPER)
      ..helperTexts = [
        _parseHelperText(UpdatescreenHelperKeys.TITLE_KEY, args.title),
        _parseHelperText(UpdatescreenHelperKeys.POSITIV_KEY, args.positivButton),
        ...args.lines.map((element) => _parseHelperText(
          "${UpdatescreenHelperKeys.LINES_KEY}:${args.lines.indexOf(element)}",
          element)
        ),
      ]
      ..helperBoxes =  [_parseHelperBox(UpdatescreenHelperKeys.BACKGROUND_KEY, args.bodyBox)]
      ..helperImages = args.headerMedia?.url != null && args.headerMedia.url.isNotEmpty ?
        [_parseHelperImage(UpdatescreenHelperKeys.IMAGE_KEY, args.headerMedia)]:[];


  static HelperEntity parseAnchoredHelper(CreateAnchoredHelper args)
    => _parseConfig(args.config, HelperType.ANCHORED_OVERLAYED_HELPER)
      ..helperTexts = [
        _parseHelperText(AnchoredscreenHelperKeys.TITLE_KEY, args.title),
        _parseHelperText(AnchoredscreenHelperKeys.DESCRIPTION_KEY, args.description),
        _parseHelperText(AnchoredscreenHelperKeys.POSITIV_KEY, args.positivButton),
        _parseHelperText(AnchoredscreenHelperKeys.NEGATIV_KEY, args.negativButton),
      ]
      ..helperBoxes =  [_parseHelperBox(args.bodyBox.key, args.bodyBox)];

  //-------------------------------------------------------------
  //-------------------------------------------------------------
  
  static HelperBoxEntity _parseHelperBox(String key, HelperBoxConfig boxConfig) {
    return HelperBoxEntity(
        id: boxConfig?.id,
        key: key,
        backgroundColor: boxConfig?.color,
      );
  }

  static HelperTextEntity _parseHelperText(String key, HelperTextConfig textConfig) {
    return HelperTextEntity(
        id: textConfig?.id,
        fontColor: textConfig?.fontColor,
        fontWeight: textConfig?.fontWeight,
        fontSize: textConfig?.fontSize,
        value: textConfig?.text,
        fontFamily: textConfig?.fontFamily,
        key: key,
      );
  } 
  
  static HelperEntity _parseConfig(CreateHelperConfig config, HelperType type)
    => HelperEntity(
      id: config.id,
      name: config.name,
      type: type,
      triggerType: config.triggerType,
      priority: config.priority,
    );

  static HelperImageEntity _parseHelperImage(String key, HelperMediaConfig mediaConfig) 
    => HelperImageEntity(id: mediaConfig.id, url: mediaConfig.url, key: key);
}