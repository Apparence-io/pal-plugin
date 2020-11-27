import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';

import 'helper_editor_models.dart';

class HelperEditorAdapter {
  
  static HelperEntity parseSimpleHelper(String pageId, CreateSimpleHelper args)
    => _parseConfig(args.config, HelperType.SIMPLE_HELPER)
        ..helperTexts = [_parseHelperText(SimpleHelperKeys.CONTENT_KEY, args.titleText)]
        ..helperBoxes =  [_parseHelperBox(SimpleHelperKeys.BACKGROUND_KEY, args.boxConfig)];
  
  static HelperEntity parseFullscreenHelper(String pageId, CreateFullScreenHelper args)
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

  
  static HelperEntity parseUpdateHelper(String pageId, CreateUpdateHelper args)
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

  //-------------------------------------------------------------
  //-------------------------------------------------------------
  
  static HelperBoxEntity _parseHelperBox(String key, HelperBoxConfig boxConfig) {
    return HelperBoxEntity(
        id: boxConfig?.id,
        key: SimpleHelperKeys.BACKGROUND_KEY,
        backgroundColor: boxConfig?.color,
      );
  }

  static HelperTextEntity _parseHelperText(String key, HelperTextConfig textConfig, ) {
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
      versionMinId: config.versionMinId,
      versionMaxId: config.versionMaxId,
    );

  static HelperImageEntity _parseHelperImage(String key, HelperMediaConfig mediaConfig) 
    => HelperImageEntity(id: mediaConfig.id, url: mediaConfig.url, key: key);
}