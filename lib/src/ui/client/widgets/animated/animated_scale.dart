import 'package:flutter/material.dart';

class AnimatedScaleWidget extends AnimatedWidget {
  final AnimationController animationController;
  final Tween<double>? scale;
  final Curve curve;
  final Widget widget;

  AnimatedScaleWidget({
    Key? key,
    required this.animationController,
    required this.widget,
    this.curve = Curves.ease,
    this.scale,
  }) : super(key: key, listenable: animationController);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: ((scale?.begin != null && scale?.end != null) ? scale : Tween<double>(begin: 0.0, end: 1.0))!.animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.ease,
        ),
      ),
      child: widget,
    );
  }
}
