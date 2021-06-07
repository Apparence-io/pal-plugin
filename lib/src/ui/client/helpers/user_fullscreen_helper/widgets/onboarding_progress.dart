import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// class ProgressionModel extends ChangeNotifier {
//   int current;
//   double activeWidth;
//   double deltaX;

//   ProgressionModel({
//     this.activeWidth = 32,
//     this.deltaX = 0,
//     int? current
//   }) : this.current = current ?? 0;
// }

class OnboardingProgress extends AnimatedWidget {

  final int progression;
  final double radius;
  final int steps;
  final Color inactiveColor, activeColor;
  final double activeRadius;
  final Animation<double> _deltaX2Anim, _deltaX1Anim;

  OnboardingProgress({ 
    required AnimationController controller,
    required this.inactiveColor,
    required this.activeColor,
    required this.steps,
    required this.activeRadius,
    this.progression = 0,
    this.radius  = 8
  }) : _deltaX2Anim = CurvedAnimation(
      parent: controller,
      curve: Interval(0, .5, curve: Curves.easeIn),
    ), 
    _deltaX1Anim = CurvedAnimation(
      parent: controller,
      curve: Interval(.5, 1, curve: Curves.decelerate)
    ), 
    super(listenable: controller);

  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: radius * 2,
          minHeight: radius * 2,
          maxWidth: double.infinity,
          minWidth: double.infinity
        ),
        child: CustomPaint(
          willChange: true,
          painter: _OnboardingProgressPainter(
            current: progression,
            radius: radius,
            activeRadius: activeRadius,
            inactiveColor: inactiveColor,
            activeColor: activeColor,
            deltaX1: _deltaX1,
            deltaX2: _deltaX2,
            steps: steps
          ),
      ),
    );
  }

  double get maxSpace => radius * 1.5;

  double get _deltaX2 => _deltaX2Anim.value * maxSpace;

  double get _deltaX1  => _deltaX1Anim.value * maxSpace;
}

class _OnboardingProgressPainter extends CustomPainter {

  final Color inactiveColor, activeColor;
  final double radius;
  final double activeRadius;
  final int steps;
  final int current;
  final double deltaX2, deltaX1;

  _OnboardingProgressPainter({
    required this.current, 
    required this.deltaX1, 
    required this.deltaX2, 
    required this.radius,
    required this.inactiveColor,
    required this.activeColor,
    required this.steps,
    required this.activeRadius,
  }): super();

  double get space => radius * 3;

  @override
  void paint(Canvas canvas, Size size) {
    var inactivePainter = Paint()
      ..style = PaintingStyle.fill
      ..color = inactiveColor;
    canvas.save();
    canvas.translate(size.width / 2, 0);
    int i = 0;  
    canvas.translate(((-steps - 1)/4) * space, 0);
    while(i < steps) {
      canvas.drawCircle(Offset.zero, radius, inactivePainter);
      canvas.translate(space, 0);
      i++;
    }
    canvas.restore();
    drawCurrent(canvas, size);
  }

  void drawCurrent(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, -radius);
    canvas.translate(((-steps - 1)/4) * radius * 4, 0);
    canvas.translate(radius * 3 * current, 0);
    var activePainter = Paint()
      ..style = PaintingStyle.fill
      ..color = activeColor;
    var path = Path();
    var diameter = radius * 2; 
    var activeWidth = deltaX2 - deltaX1;
    canvas.translate(deltaX1, 0);
    path.arcTo(Rect.fromLTWH(deltaX1, 0, diameter, diameter), -3 * pi/2, pi, false);
    path.lineTo(activeWidth, 0);
    path.arcTo(Rect.fromLTWH(deltaX2, 0, diameter, diameter), 3 * pi/2, pi, false);
    path.close();
    canvas.drawPath(path, activePainter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OnboardingProgressPainter oldDelegate) 
    => true;
}