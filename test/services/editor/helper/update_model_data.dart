import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';

genUpdateModelData({HelperGroupConfig? groupConfig})
  => CreateUpdateHelper(
    helperGroup: groupConfig ?? HelperGroupConfig(
      id: "3872983729JJF"
    ),
    config: CreateHelperConfig(
      name: 'my helper name 2',
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      priority: 1,
      route: "myPageRoute",
      helperType: HelperType.UPDATE_HELPER,
    ),
    title: HelperTextConfig(
      text: "Today tips is now this lorem ipsum lorem ipsum...",
      fontColor: "#CCC",
      fontWeight: "w100",
      fontSize: 21,
      fontFamily: "cortana",
    ),
    lines: [
      HelperTextConfig(
        text: "Line 1",
        fontColor: "#CCC2",
        fontWeight: "w100E",
        fontSize: 212,
        fontFamily: "cortana2",
      ),
      HelperTextConfig(
        text: "Line 2",
        fontColor: "#CCC2",
        fontWeight: "w100E",
        fontSize: 212,
        fontFamily: "cortana2",
      )
    ],
    bodyBox: HelperBoxConfig(color: '#CCF'),
    headerMedia: HelperMediaConfig(url: 'url'),
  );

genExpectedUpdateEntity(CreateUpdateHelper args)
  => HelperEntity(
    name: args.config.name,
    type: HelperType.UPDATE_HELPER,
    triggerType: HelperTriggerType.ON_SCREEN_VISIT,
    priority: 1,
    helperTexts: [
      HelperTextEntity(
        value: args.title!.text,
        fontColor: args.title!.fontColor,
        fontWeight: args.title!.fontWeight,
        fontSize: args.title!.fontSize,
        fontFamily: args.title!.fontFamily,
        key: UpdatescreenHelperKeys.TITLE_KEY,
      ),
      HelperTextEntity(
        value: args.lines[0].text,
        fontColor: args.lines[0].fontColor,
        fontWeight: args.lines[0].fontWeight,
        fontSize: args.lines[0].fontSize,
        fontFamily: args.lines[0].fontFamily,
        key: "${UpdatescreenHelperKeys.LINES_KEY}:0",
      ),
      HelperTextEntity(
        value: args.lines[1].text,
        fontColor: args.lines[1].fontColor,
        fontWeight: args.lines[1].fontWeight,
        fontSize: args.lines[1].fontSize,
        fontFamily: args.lines[1].fontFamily,
        key: "${UpdatescreenHelperKeys.LINES_KEY}:1",
      ),
    ],
    helperImages: [
      HelperImageEntity(
        url: args.headerMedia.url,
        key: FullscreenHelperKeys.IMAGE_KEY,
      )
    ],
    helperBoxes: [
      HelperBoxEntity(
        key: FullscreenHelperKeys.BACKGROUND_KEY,
        backgroundColor: args.bodyBox!.color,
      )
    ]);
