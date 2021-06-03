
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

class ScreenText extends StatelessWidget {
  final HelperTextViewModel model;
  final Key? textKey;

  const ScreenText({ 
    Key? key,
    this.textKey,
    required this.model 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      model.text ?? 'Empty text',
      key: textKey,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: model.fontColor ?? Colors.white,
        fontSize: model.fontSize ?? 60.0,
        fontWeight: model.fontWeight,
      ).merge(GoogleFonts.getFont(model.fontFamily ?? 'Montserrat')));
  }
}