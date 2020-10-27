import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/simple_helper.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper.dart';

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
        return _createSimpleHelper(helper, onTrigger);
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        return _createUpdateHelper(helper, onTrigger);
        break;
    }
    return null;
  }

  static Widget _createHelperFullScreen(final HelperEntity helper, final Function onTrigger){
    return UserFullScreenHelperPage(
      // helperText: helper.title, //FIXME
      // bgColor: HexColor.fromHex(helper.backgroundColor),
      // textColor: HexColor.fromHex(helper.fontColor),
      // textSize: 18,
      // onTrigger: onTrigger,
    );
  }


  static Widget _createSimpleHelper(
      final HelperEntity helper, final Function onTrigger) {
    return SimpleHelperLayout(
      toaster: SimpleHelperPage(
        descriptionLabel: CustomLabel(
            fontColor: Colors.white,
            fontSize: 14,
            text:
                "You can just disable notification by going in your profile and click on notifications tab > disable notifications"),
        backgroundColor: Colors.black,
      ),
      onDismissed: (res) => onTrigger(res == DismissDirection.startToEnd),
    );
  }

  //TODO
  static Widget _createUpdateHelper(
      final HelperEntity helper, final Function onTrigger) {
  return SimpleHelperLayout(
      toaster: SimpleHelperPage(
        descriptionLabel: CustomLabel(
            fontColor: Colors.white,
            fontSize: 14,
            text:
                "You can just disable notification by going in your profile and click on notifications tab > disable notifications"),
        backgroundColor: Colors.black,
      ),
      onDismissed: (res) => onTrigger(res == DismissDirection.startToEnd),
    );
  }
}
