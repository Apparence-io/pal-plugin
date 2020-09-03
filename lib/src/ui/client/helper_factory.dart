import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_full_screen_entity.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper_widget.dart';
import 'package:palplugin/src/extensions/color_extension.dart';

class HelperFactory {
  static Widget build(final HelperEntity helper){
    switch(helper.runtimeType){
      case HelperFullScreenEntity :

        return _createHelperFullScreen(helper as HelperFullScreenEntity);
    }
    return null;
  }

  static Widget _createHelperFullScreen(final HelperFullScreenEntity helper){
    return UserFullscreenHelperWidget(
      helperText: helper.title,
      bgColor: HexColor.fromHex(helper.backgroundColor),
      textColor: HexColor.fromHex(helper.fontColor),
      textSize: 18,
    );
  }
}