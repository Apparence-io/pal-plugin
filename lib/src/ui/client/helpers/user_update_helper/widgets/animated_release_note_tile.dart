import 'package:flutter/material.dart';

class AnimatedReleaseNoteTile extends AnimatedWidget {
  int index;
  String text;
  Color fontColor;
  double fontSize;
  final AnimationController animationController;
  final double animationStart;
  final double animationEnd;
  Animation<double> opacityAnim;
  Animation<double> verticalOffsetAnim;

  AnimatedReleaseNoteTile({
    Key key,
    @required this.index,
    @required this.text,
    this.fontColor,
    this.fontSize,
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
    Color fontColorDefault = fontColor ?? Colors.white;
    double fontSizeDefault = fontSize ?? 15.0;

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
            ),
            children: <TextSpan>[
              TextSpan(
                text: this.text,
                style: TextStyle(
                  color: fontColorDefault,
                  fontSize: fontSizeDefault,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
