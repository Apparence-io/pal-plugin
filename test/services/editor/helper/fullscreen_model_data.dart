import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';

genFullscreenModel({HelperGroupConfig groupConfig})
  => CreateFullScreenHelper(
    helperGroup: groupConfig ?? HelperGroupConfig(
      id: "3872983729JJF"
    ),
    config: CreateHelperConfig(
      name: 'my helper name',
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      priority: 1,
      route: "myPageRoute",
      helperType: HelperType.HELPER_FULL_SCREEN,
    ),
    title: HelperTextConfig(
      text: "Today tips is now this lorem ipsum lorem ipsum...",
      fontColor: "#CCC",
      fontWeight: "w100",
      fontSize: 21,
      fontFamily: "cortana"),
    description: HelperTextConfig(
      text: "Description lorem ipsum...",
      fontColor: "#CCC2",
      fontWeight: "w400",
      fontSize: 14,
      fontFamily: "cortanaBis"),
    bodyBox: HelperBoxConfig(
      color: '#CCF',
    ),
    mediaHeader: HelperMediaConfig(url: "http://image.png/"),
  );

genExpectedFullscreenEntity(CreateFullScreenHelper args)
  => HelperEntity(
    id: null,
    name: args.config.name,
    type: HelperType.HELPER_FULL_SCREEN,
    triggerType: HelperTriggerType.ON_SCREEN_VISIT,
    priority: 1,
    helperTexts: [
      HelperTextEntity(
        value: args.title.text,
        fontColor: args.title.fontColor,
        fontWeight: args.title.fontWeight,
        fontSize: args.title.fontSize,
        fontFamily: args.title.fontFamily,
        key: FullscreenHelperKeys.TITLE_KEY,
      ),
      HelperTextEntity(
        value: args.description.text,
        fontColor: args.description.fontColor,
        fontWeight: args.description.fontWeight,
        fontSize: args.description.fontSize,
        fontFamily: args.description.fontFamily,
        key: FullscreenHelperKeys.DESCRIPTION_KEY,
      ),
    ],
    helperImages: [
      HelperImageEntity(
        url: args.mediaHeader.url,
        key: FullscreenHelperKeys.IMAGE_KEY,
      )
    ],
    helperBoxes: [
      HelperBoxEntity(
        key: FullscreenHelperKeys.BACKGROUND_KEY,
        backgroundColor: args.bodyBox.color,
      )
    ],
  );