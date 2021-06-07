import 'package:flutter/material.dart';

enum AnimationType {
  FADE, TRANSLATION,
}

/// this is usefull to create a nice animation combo 
class AnimationSet {
  final Map<AnimationType, Animation<double>> animations;

  AnimationSet._(this.animations);

  factory AnimationSet.fadeAndTranslate(AnimationController controller, double startInterval) 
    =>  AnimationSet._({
      AnimationType.FADE: CurvedAnimation(
        parent: controller,
        curve: Interval(startInterval, startInterval + .6, curve: Curves.easeIn),
      ),
      AnimationType.TRANSLATION: CurvedAnimation(
        parent: controller,
        curve: Interval(startInterval, startInterval + .6, curve: Curves.decelerate),
      ),
    });

  Animation<double> get opacity => animations[AnimationType.FADE]!;  

  Animation<double> get translation => animations[AnimationType.TRANSLATION]!;  
}