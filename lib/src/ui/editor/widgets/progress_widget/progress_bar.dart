import 'package:flutter/material.dart';
import 'package:pal/src/theme.dart';

/* Bar render class : Renders the progress bar with the given value */
class ProgressBarRender extends StatefulWidget {
  final double? value;

  const ProgressBarRender({Key? key, this.value}) : super(key: key);

  @override
  _ProgressBarRenderState createState() => _ProgressBarRenderState();
}

class _ProgressBarRenderState extends State<ProgressBarRender> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              //* ANIMATION MOVES THE LEFT GRADIENT COLOR
              stops: [
                widget.value!,
                0
              ],
              // IN THE ORDER BELOW : DARK / GREY
              colors: [
                PalTheme.of(context)!.colors.dark!,
                Color(0xFFC1BFD6),
              ]),
        ),
        // PROGRESS BAR HEIGHT
        child: Container(
          height: 4,
        ),
      ),
    );
  }
}
