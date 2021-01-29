import 'package:flutter/material.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

class EditorSaveFloatingButton extends StatelessWidget {
  final Function onTap;

  const EditorSaveFloatingButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kFloatingRadius = 45.0;

    return CircleIconButton(
      key: ValueKey('editableActionBarValidateButton'),
      backgroundColor: PalTheme.of(context).colors.color2,
      radius: 40.0,
      borderSide: BorderSide(
        color: Colors.white,
        width: 3,
      ),
      shadow: BoxShadow(
        color: Colors.black.withOpacity(0.15),
        spreadRadius: 4,
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
      icon: Icon(
        Icons.save,
        color: Colors.white,
        size: kFloatingRadius,
      ),
      onTapCallback: onTap,
    );
  }
}
