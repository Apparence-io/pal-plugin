import 'package:flutter/material.dart';

class AnimatedLogo extends AnimatedWidget {
  final AnimationController animationController;

  AnimatedLogo({
    Key key,
    @required this.animationController,
  }) : super(key: key, listenable: animationController);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.elasticOut,
        ),
      ),
      child: Image.asset(
        'packages/palplugin/assets/images/create_helper.png',
        key: ValueKey('pal_UserUpdateHelperWidget_Icon_Image'),
        // height: 282.0,
      ),
    );
  }
}
