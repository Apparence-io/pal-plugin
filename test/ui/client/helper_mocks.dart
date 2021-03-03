import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';


abstract class MockHelperEntityBuilder {

  HelperEntity create(String id, {String title}); 
}

class MockFullscreenHelperEntityBuilder implements MockHelperEntityBuilder {
  @override
  HelperEntity create(String id, {String title}) 
    => HelperEntity(
      id: id,
      name: "helper name",
      type: HelperType.HELPER_FULL_SCREEN,
      triggerType: HelperTriggerType.ON_SCREEN_VISIT, // remove me
      priority: 1,
      versionMinId: 25,
      versionMaxId: 25,
      helperTexts: [
        HelperTextEntity(
          value: title ?? "args.title.text",
          fontColor: "#000000",
          fontWeight: "w100",
          fontSize: 10,
          key: FullscreenHelperKeys.TITLE_KEY,
        ),
        HelperTextEntity(
          value: "args.title.text",
          fontColor: "#000000",
          fontWeight: "w100",
          fontSize: 10,
          key: FullscreenHelperKeys.DESCRIPTION_KEY,
        ),
      ],
      helperBoxes: [
        HelperBoxEntity(
          key: FullscreenHelperKeys.BACKGROUND_KEY,
          backgroundColor: "#CCCCCC",
        )
      ],
    );

}