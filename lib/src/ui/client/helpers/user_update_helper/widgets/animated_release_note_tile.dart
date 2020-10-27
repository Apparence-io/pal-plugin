import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';

class AnimatedReleaseNoteTile extends AnimatedWidget {
  int index;
  final CustomLabel customLabel;
  final AnimationController animationController;
  final double animationStart;
  final double animationEnd;
  Animation<double> opacityAnim;
  Animation<double> verticalOffsetAnim;

  AnimatedReleaseNoteTile({
    Key key,
    @required this.index,
    @required this.customLabel,
    @required this.animationController,
    @required this.animationStart,
    @required this.animationEnd,
  }) : super(key: key, listenable: animationController) {
    this.opacityAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          animationStart,
          animationEnd,
          curve: Curves.decelerate,
        ),
      ),
    );
    this.verticalOffsetAnim = Tween<double>(begin: -20, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          animationStart,
          animationEnd,
          curve: Curves.decelerate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color fontColorDefault = this.customLabel.fontColor ?? Colors.white;
    double fontSizeDefault = this.customLabel.fontSize ?? 15.0;
    FontWeight fontWeightDefault = this.customLabel.fontWeight ?? FontWeight.normal;
    String fontFamilyDefault = this.customLabel.fontFamily ?? 'Montserrat';
    return Transform.translate(
      offset: Offset(0, verticalOffsetAnim.value),
      child: Opacity(
        opacity: opacityAnim != null ? opacityAnim.value : 1,
        child: RichText(
          key: ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_$index'),
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '•  ',
            style: TextStyle(
              color: fontColorDefault,
              fontSize: fontSizeDefault,
              fontWeight: FontWeight.w900,
            ).merge(GoogleFonts.getFont(fontFamilyDefault)),
            children: <TextSpan>[
              TextSpan(
                text: this.customLabel.text,
                style: TextStyle(
                  color: fontColorDefault,
                  fontSize: fontSizeDefault,
                  fontWeight: fontWeightDefault,
                ).merge(GoogleFonts.getFont(fontFamilyDefault))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
