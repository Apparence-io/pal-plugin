import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/shared/widgets/circle_button.dart';

class EditorButton extends StatelessWidget {

  final Function onPressed;
  final double size;
  final Icon icon;
  final Color bgColor, iconColor;
  final bool bordered;

  EditorButton({this.onPressed, this.size, this.icon, this.bgColor, this.iconColor, this.bordered = false, Key key}) : super(key: key);

  factory EditorButton.validate(PalThemeData theme, Function onPressed, {Key key}) => EditorButton(
    onPressed: onPressed,
    size: 52,
    icon: Icon(Icons.check, size: 32, color: theme.colors.dark),
    bgColor: theme.colors.color3,
    key: key
  );

  factory EditorButton.cancel(PalThemeData theme, Function onPressed, {Key key}) => EditorButton(
    onPressed: onPressed,
    size: 40,
    icon: Icon(Icons.close, size: 24, color: theme.colors.accent),
    bgColor: theme.colors.light,
    key: key
  );

  factory EditorButton.editMode(PalThemeData theme, Function onPressed, {Key key}) => EditorButton(
    onPressed: onPressed,
    size: 52,
    icon: Icon(Icons.mode_edit, size: 32, color: theme.colors.light),
    bgColor: theme.colors.color3,
    bordered: true,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      icon: icon,
      radius: size / 2,
      backgroundColor: bgColor,
      onTapCallback: onPressed,
    );
  }
}

