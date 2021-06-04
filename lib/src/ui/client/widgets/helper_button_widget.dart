import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

class HelperButton extends StatelessWidget {

  final HelperButtonViewModel model;
  final Function onPressed;
  final Key? buttonKey;

  const HelperButton({ 
    Key? key,
    required this.model, 
    required this.onPressed,
    this.buttonKey
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if(model.buttonStyle == HelperButtonStyle.BORDERED) {
      return OutlinedButton(
        key: buttonKey,
        onPressed: () {
          HapticFeedback.selectionClick();
          onPressed();
        },
        style: outlineButtonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            model.text ?? '',
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      );
    }
    return TextButton(
      key: buttonKey,
      onPressed: () {
        HapticFeedback.selectionClick();
        onPressed();
      },
      style: textButtonStyle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          model.text ?? '',
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }

  ButtonStyle get outlineButtonStyle => OutlinedButton.styleFrom(
    primary: model.fontColor ?? Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
    minimumSize: Size(88, 36),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    textStyle: textStyle
  ).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) => BorderSide(
        color: model.fontColor != null ? model.fontColor! : Colors.white, 
        width: model.buttonStyle == HelperButtonStyle.BORDERED ? 1 : 0,
      ),
    ),
  );

  ButtonStyle get textButtonStyle => TextButton.styleFrom(
    primary: model.fontColor ?? Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
    minimumSize: Size(88, 36),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    textStyle: textStyle
  );

  TextStyle get textStyle => TextStyle(
        fontSize: model.fontSize,
        fontWeight: model.fontWeight,
        color: model.fontColor ?? Colors.white,
      ).merge(GoogleFonts.getFont(model.fontFamily ?? 'Montserrat'));
}