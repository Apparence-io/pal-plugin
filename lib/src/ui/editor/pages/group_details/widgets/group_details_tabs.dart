// ****TAB WIDGET
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GroupDetailsTabWidget extends StatelessWidget {
  final String label;
  final bool active;
  final Function onTap;

  const GroupDetailsTabWidget(
      {Key key, this.label, this.active = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: CustomPaint(
        painter: TabCustomBorder(this.active),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(this.label),
            ],
          ),
        ),
      ),
    );
  }
}

class TabCustomBorder extends CustomPainter {
  final bool active;

  TabCustomBorder(this.active);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.strokeWidth = 4;
    paint.shader = ui.Gradient.linear(
        Offset(0, size.height),
        Offset(size.width, size.height),
        [Color(0xFF2C77B6), Color(0xFF90E0EF)]);
    if (this.active)
      canvas.drawLine(
          Offset(0, size.height), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
// *****TAB WIDGET