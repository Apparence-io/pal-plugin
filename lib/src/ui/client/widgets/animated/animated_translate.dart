import 'package:flutter/material.dart';

class AnimatedTranslateWidget extends AnimatedWidget {
  final AnimationController animationController;
  final Tween<double> opacity;
  final Tween<Offset> position;
  final Widget widget;
  final Curve positionCurve;
  final Curve opacityCurve;

  AnimatedTranslateWidget({
    Key key,
    @required this.animationController,
    @required this.widget,
    this.opacity,
    this.position,
    this.positionCurve = Curves.ease,
    this.opacityCurve = Curves.ease,
  }) : super(key: key, listenable: animationController);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: ((opacity?.begin != null && opacity?.end != null)
              ? opacity
              : Tween<double>(begin: 0, end: 1))
          .animate(
        CurvedAnimation(
          parent: animationController,
          curve: opacityCurve,
        ),
      ),
      child: SlideTransition(
        position: ((position?.begin != null && position?.end != null)
                ? position
                : Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)))
            .animate(
          CurvedAnimation(
            parent: animationController,
            curve: positionCurve,
          ),
        ),
        child: widget,
      ),
    );
  }
}
