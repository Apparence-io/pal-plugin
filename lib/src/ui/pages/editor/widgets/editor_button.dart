import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';

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
    key: key
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 52,
      height: size ?? 52,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: PalTheme.of(context).colors.dark.withOpacity(0.15), blurRadius: 6, spreadRadius: 2, offset: Offset(0, 6))
        ],
        border: bordered ? Border.all(color: PalTheme.of(context).colors.color2, width: 2) : null,
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}

