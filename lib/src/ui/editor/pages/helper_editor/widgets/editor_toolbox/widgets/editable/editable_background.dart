import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditableBackground extends StatelessWidget {
  final Color? backgroundColor;
  final Widget widget;
  final bool? isSelected;

  const EditableBackground({
    Key? key,
    required this.backgroundColor,
    required this.widget,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _borderColor = this.backgroundColor!.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return Container(
      color: this.backgroundColor,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: DottedBorder(
          strokeWidth: 2.0,
          strokeCap: StrokeCap.round,
          dashPattern: [10, 7],
          color: _borderColor.withAlpha(80),
          child: Stack(
            fit: StackFit.expand,
            children: [
              this.widget,
            ],
          ),
        ),
      ),
    );
  }
}
