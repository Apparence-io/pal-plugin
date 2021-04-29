import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/extensions/color_extension.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

class AnchoredHelperModel {

  final HelperTextViewModel? title;
  final HelperTextViewModel? description;
  final HelperTextViewModel? positivBtn;
  final HelperTextViewModel? negativBtn;

  final Color? bgColor;
  final String? anchorKey;

  AnchoredHelperModel._({
    this.title, this.description, 
    this.positivBtn, this.negativBtn, 
    this.bgColor, this.anchorKey
  });

  factory AnchoredHelperModel.fromEntity(HelperEntity entity) => 
    AnchoredHelperModel._(
      title: HelperSharedFactory.parseTextLabel(AnchoredscreenHelperKeys.TITLE_KEY, entity.helperTexts!),
      description: HelperSharedFactory.parseTextLabel(AnchoredscreenHelperKeys.DESCRIPTION_KEY, entity.helperTexts!),
      positivBtn: HelperSharedFactory.parseTextLabel(AnchoredscreenHelperKeys.POSITIV_KEY, entity.helperTexts!),
      negativBtn: HelperSharedFactory.parseTextLabel(AnchoredscreenHelperKeys.NEGATIV_KEY, entity.helperTexts!),
      bgColor: HexColor.fromHex(entity.helperBoxes!.first.backgroundColor!),
      anchorKey: entity.helperBoxes!.first.key
    );


}