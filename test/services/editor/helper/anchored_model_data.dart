import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';

generateAnchoredHelperData({HelperGroupConfig? helperGroupConfig})
  => CreateAnchoredHelper(
    helperGroup: helperGroupConfig ?? HelperGroupConfig(
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
    description: HelperTextConfig(
      text: "Today description is now this lorem ipsum lorem ipsum...",
      fontColor: "#CCC",
      fontWeight: "w100",
      fontSize: 16,
      fontFamily: "cortana",
    ),
    positivButton: HelperTextConfig(
      text: "Ok, thanks",
      fontColor: "#CCC",
      fontWeight: "w100",
      fontSize: 16,
      fontFamily: "cortana",
    ),
    negativButton: HelperTextConfig(
      text: "Not helping",
      fontColor: "#CCC",
      fontWeight: "w100",
      fontSize: 16,
      fontFamily: "cortana",
    ),
    bodyBox: HelperBoxConfig(
      key: 'KEY_WIDGET_KEY',
      color: '#000',
    )
  );

genExpectedHelperEntity(CreateAnchoredHelper args)
  => HelperEntity(
    name: args.config.name,
    type: HelperType.ANCHORED_OVERLAYED_HELPER,
    triggerType: HelperTriggerType.ON_SCREEN_VISIT,
    priority: 1,
    helperTexts: [
      HelperTextEntity(
        value: args.title!.text,
        fontColor: args.title!.fontColor,
        fontWeight: args.title!.fontWeight,
        fontSize: args.title!.fontSize,
        fontFamily: args.title!.fontFamily,
        key: AnchoredscreenHelperKeys.TITLE_KEY,
      ),
      HelperTextEntity(
        value: args.description!.text,
        fontColor: args.description!.fontColor,
        fontWeight: args.description!.fontWeight,
        fontSize: args.description!.fontSize,
        fontFamily: args.description!.fontFamily,
        key: AnchoredscreenHelperKeys.DESCRIPTION_KEY,
      ),
      HelperTextEntity(
        value: args.positivButton!.text,
        fontColor: args.positivButton!.fontColor,
        fontWeight: args.positivButton!.fontWeight,
        fontSize: args.positivButton!.fontSize,
        fontFamily: args.positivButton!.fontFamily,
        key: AnchoredscreenHelperKeys.POSITIV_KEY,
      ),
      HelperTextEntity(
        value: args.negativButton!.text,
        fontColor: args.negativButton!.fontColor,
        fontWeight: args.negativButton!.fontWeight,
        fontSize: args.negativButton!.fontSize,
        fontFamily: args.negativButton!.fontFamily,
        key: AnchoredscreenHelperKeys.NEGATIV_KEY,
      ),
    ],
    helperBoxes: [
      HelperBoxEntity(
        key: args.bodyBox!.key,
        backgroundColor: args.bodyBox!.color,
      )
    ]
  );
