import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

class EditableBackground extends StatelessWidget {
  final Color backgroundColor;
  final Function() onColorChange;
  final Widget widget;
  final String circleIconKey;

  const EditableBackground({
    Key key,
    @required this.backgroundColor,
    @required this.onColorChange,
    @required this.widget,
    @required this.circleIconKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: DottedBorder(
          strokeWidth: 2.0,
          strokeCap: StrokeCap.round,
          dashPattern: [10, 7],
          color: Colors.white.withAlpha(80),
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget,
              Positioned(
                top: 20.0,
                left: 20.0,
                child: SafeArea(
                  child: CircleIconButton(
                    key: ValueKey(circleIconKey),
                    icon: Icon(Icons.invert_colors),
                    backgroundColor: PalTheme.of(context).colors.light,
                    onTapCallback: onColorChange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
