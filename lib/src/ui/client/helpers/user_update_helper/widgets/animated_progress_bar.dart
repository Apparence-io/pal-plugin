import 'package:flutter/material.dart';

class AnimatedProgressBar extends AnimatedWidget {
  final AnimationController animationController;
  final Animation<Color> valueColor;
  final Color backgroundColor;
  final Animation<double> progressValueAnim;

  AnimatedProgressBar({
    Key key,
    @required this.animationController,
    this.valueColor,
    this.backgroundColor = Colors.grey,
  }) : this.progressValueAnim = Tween<double>(begin: 0, end: 1).animate(animationController),
     super(key: key, listenable: animationController);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progressValueAnim.value,
      valueColor: valueColor ?? AlwaysStoppedAnimation<Color>(Colors.white),
      backgroundColor: backgroundColor,
    );
  }
}
