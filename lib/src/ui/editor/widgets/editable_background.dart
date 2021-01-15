import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditableBackground extends StatefulWidget {
  final ValueNotifier<Color> backgroundColor;
  // final Function() onColorChange;
  final Widget widget;
  // final String circleIconKey;

  const EditableBackground({
    Key key,
    @required this.backgroundColor,
    // @required this.onColorChange,
    @required this.widget,
    // @required this.circleIconKey,
  }) : super(key: key);

  @override
  _EditableBackgroundState createState() => _EditableBackgroundState();
}

class _EditableBackgroundState extends State<EditableBackground> {
  @override
  void initState() {
    super.initState();

    widget.backgroundColor.addListener(refreshView);
  }

  void refreshView() {
    this.setState(() {});
  }

  @override
  void dispose() {
    widget.backgroundColor.removeListener(refreshView);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIXME: When converting to stateless, use this
    return
        // ValueListenableBuilder<Color>(
        //   valueListenable: this.backgroundColor,
        //   builder: (context, color,child) =>
        Container(
      color: widget.backgroundColor.value,
      width: double.infinity,
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
              widget.widget,
              // Positioned(
              //   top: 20.0,
              //   left: 20.0,
              //   child: SafeArea(
              //     child: CircleIconButton(
              //       key: ValueKey(circleIconKey),
              //       icon: Icon(Icons.invert_colors),
              //       backgroundColor: PalTheme.of(context).colors.light,
              //       onTapCallback: onColorChange,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
