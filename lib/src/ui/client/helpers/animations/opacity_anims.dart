import 'package:flutter/material.dart';

import 'combined_animation.dart';

enum TranslationType {
  LEFT_TO_RIGHT,
  RIGHT_TO_LEFT,
  BOTTOM_TO_TOP,
}

class TranslationOpacityAnimation extends StatelessWidget {

  final TranslationType translationType;
  final AnimationController controller;
  final Animation<double> translateAnim, opacityAnim;
  final Widget child;

  const TranslationOpacityAnimation({ 
    Key? key,
    required this.controller,
    required this.translateAnim,
    required this.opacityAnim,
    required this.child,
    TranslationType? translationType,
  }) : this.translationType = translationType ?? TranslationType.LEFT_TO_RIGHT,
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: offset,
        child: Opacity(
          opacity: opacityAnim.value,
          child: child,
        ),
      ),
      child: child,
    );
  }

  Offset get offset {
    switch(translationType) {
      case TranslationType.BOTTOM_TO_TOP:
        return bottomToTop;
      case TranslationType.LEFT_TO_RIGHT:
      default:
        return controller.status == AnimationStatus.forward 
          ? leftToRight : leftToRightReversed;
    }
  }

  Offset get bottomToTop => Offset(0, 100 - ((translateAnim.value) * 100));

  Offset get leftToRight => Offset(-100 + ((translateAnim.value) * 100), 0);

  Offset get leftToRightReversed => Offset(100 - ((translateAnim.value) * 100), 0);


}