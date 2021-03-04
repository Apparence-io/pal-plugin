  import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/extensions/color_extension.dart';

var validAnchoredHelperEntity = HelperEntity(
      id:"myhelperid",
      name: "my helper name",
      type: HelperType.ANCHORED_OVERLAYED_HELPER,
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      priority: 1,
      helperTexts: [
        HelperTextEntity(
          value: "args.title.text",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.TITLE_KEY,
        ),
        HelperTextEntity(
          value: "args.title.descr",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.DESCRIPTION_KEY,
        ),
        HelperTextEntity(
          value: "ok",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.POSITIV_KEY,
        ),
        HelperTextEntity(
          value: "not_ok",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.NEGATIV_KEY,
        ),
      ],
      helperBoxes: [
        HelperBoxEntity(
          key: "[<'text1'>]",
          backgroundColor: Colors.black.toHex(),
        )
      ]
    );

var helperEntityKeyNotFound = HelperEntity(
  id: "myhelperid",
  name: "my helper name",
  type: HelperType.ANCHORED_OVERLAYED_HELPER,
  triggerType: HelperTriggerType.ON_SCREEN_VISIT,
  priority: 1,
  helperTexts: [
    HelperTextEntity(
      value: "args.title.text",
      fontColor: "FFFFFF",
      fontWeight: "Normal",
      fontSize: 21,
      fontFamily: "Montserrat",
      key: AnchoredscreenHelperKeys.TITLE_KEY,
    ),
    HelperTextEntity(
      value: "args.title.descr",
      fontColor: "FFFFFF",
      fontWeight: "Normal",
      fontSize: 21,
      fontFamily: "Montserrat",
      key: AnchoredscreenHelperKeys.DESCRIPTION_KEY,
    ),
    HelperTextEntity(
      value: "ok",
      fontColor: "ffffffff",
      fontWeight: "Normal",
      fontSize: 21,
      fontFamily: "Montserrat",
      key: AnchoredscreenHelperKeys.POSITIV_KEY,
    ),
    HelperTextEntity(
      value: "not_ok",
      fontColor: "ffffffff",
      fontWeight: "Normal",
      fontSize: 21,
      fontFamily: "Montserrat",
      key: AnchoredscreenHelperKeys.NEGATIV_KEY,
    ),
  ],
  helperBoxes: [
    HelperBoxEntity(
      key: "[<'notfoundkey'>]",
      backgroundColor: Colors.black.toHex(),
    )
  ]
);