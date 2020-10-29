import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';
import 'package:palplugin/src/ui/client/widgets/animated/animated_translate.dart';

class ReleaseNoteCell extends StatelessWidget {
  final int index;
  final CustomLabel customLabel;
  final AnimationController animationController;
  final Curve positionCurve;
  final Curve opacityCurve;

  const ReleaseNoteCell({
    Key key,
    @required this.index,
    @required this.customLabel,
    @required this.animationController,
    this.positionCurve,
    this.opacityCurve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color fontColorDefault = this.customLabel.fontColor ?? Colors.white;
    double fontSizeDefault = this.customLabel.fontSize ?? 15.0;
    FontWeight fontWeightDefault =
        this.customLabel.fontWeight ?? FontWeight.normal;
    String fontFamilyDefault = this.customLabel.fontFamily ?? 'Montserrat';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AnimatedTranslateWidget(
        animationController: animationController,
        positionCurve: positionCurve,
        opacityCurve: opacityCurve,
        widget: RichText(
          key: ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_$index'),
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '•  ',
            style: TextStyle(
              color: fontColorDefault,
              fontSize: fontSizeDefault,
              fontWeight: FontWeight.w900,
            ).merge(
              GoogleFonts.getFont(fontFamilyDefault),
            ),
            children: <TextSpan>[
              TextSpan(
                text: this.customLabel.text,
                style: TextStyle(
                  color: fontColorDefault,
                  fontSize: fontSizeDefault,
                  fontWeight: fontWeightDefault,
                ).merge(
                  GoogleFonts.getFont(fontFamilyDefault),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
