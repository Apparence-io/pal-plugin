import 'package:flutter/material.dart';

enum AnimationType {
  FADE, TRANSLATE_X, TRANSLATE_Y
}

/// this is usefull to create a nice animation combo 
class AnimationSet {
  final Map<AnimationType, Animation<double>> animations;

  AnimationSet._(this.animations);

  factory AnimationSet.fadeAndTranslate(AnimationController controller, double startInterval) 
    =>  AnimationSet._({
      AnimationType.FADE: CurvedAnimation(
        parent: controller,
        curve: Interval(startInterval, startInterval + .2, curve: Curves.easeIn),
      ),
      AnimationType.TRANSLATE_X: CurvedAnimation(
        parent: controller,
        curve: Interval(startInterval, startInterval + .3, curve: Curves.decelerate),
      ),
    });

  Animation<double> get opacity => animations[AnimationType.FADE]!;  

  Animation<double> get translateHorizontal => animations[AnimationType.TRANSLATE_X]!;  

  Animation<double> get translateVertical => animations[AnimationType.TRANSLATE_Y]!;  
}