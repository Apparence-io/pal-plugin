import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_full_screen_entity.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper_widget.dart';

class HelperFactory {
  static Widget build(final HelperEntity helper){
    switch(helper.runtimeType){
      case HelperFullScreenEntity :

        return _createHelperFullScreen(helper as HelperFullScreenEntity);
    }

    return null;
  }

  static Widget _createHelperFullScreen(final HelperFullScreenEntity helperEntity){
    return UserFullscreenHelperWidget(
      helperText: helperEntity.title,
      bgColor: Color(0xFF2C77B6),
      textColor: Color(0xFFFAFEFF),
      textSize: 18,
    );
  }
}