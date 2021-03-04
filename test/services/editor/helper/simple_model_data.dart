import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';

genSimpleHelperData({HelperGroupConfig groupConfig})
  => CreateSimpleHelper(
    boxConfig: HelperBoxConfig(color: '#FFF'),
    titleText: HelperTextConfig(
      text: "Today tips is now this lorem ipsum lorem ipsum...",
      fontColor: "#CCC",
      fontWeight: "w100",
      fontSize: 21,
      fontFamily: "cortana",
    ),
    config: CreateHelperConfig(
      name: 'my helper name',
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      priority: 1,
      route: "myPageRoute",
      helperType: HelperType.SIMPLE_HELPER,
    ),
    helperGroup: groupConfig ?? HelperGroupConfig(
      id: "3872983729JJF"
    )
  );

genExpectedSimpleEntity(CreateSimpleHelper args)
  => HelperEntity(
    id: null,
    name: 'my helper name',
    type: HelperType.SIMPLE_HELPER,
    triggerType: HelperTriggerType.ON_SCREEN_VISIT,
    priority: 1,
    helperTexts: [
      HelperTextEntity(
        fontColor: "#CCC",
        fontWeight: "w100",
        fontSize: 21,
        value: "Today tips is now this lorem ipsum lorem ipsum...",
        fontFamily: "cortana",
        key: SimpleHelperKeys.CONTENT_KEY,
      )
    ],
    helperBoxes: [
      HelperBoxEntity(
        backgroundColor: "#FFF",
        key: SimpleHelperKeys.BACKGROUND_KEY,
      )
    ]);