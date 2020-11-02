import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

class EditorButton extends StatelessWidget {
  final Function onPressed;
  final double size;
  final Icon icon;
  final Color bgColor, iconColor;
  final bool bordered;
  final bool isEnabled;

  EditorButton(
      {this.onPressed,
      this.size,
      this.icon,
      this.bgColor,
      this.iconColor,
      this.bordered = false,
      this.isEnabled = true,
      Key key})
      : super(key: key);

  factory EditorButton.validate(PalThemeData theme, Function onPressed,
          {Key key, bool isEnabled = true }) =>
      EditorButton(
          onPressed: onPressed,
          size: 52,
          isEnabled: isEnabled,
          icon: Icon(Icons.check, size: 32, color: theme.colors.dark),
          bgColor: theme.colors.color3,
          key: key);

  factory EditorButton.cancel(PalThemeData theme, Function onPressed,
          {Key key, bool isEnabled = true}) =>
      EditorButton(
          onPressed: onPressed,
          size: 40,
          isEnabled: isEnabled,
          icon: Icon(Icons.close, size: 24, color: theme.colors.accent),
          bgColor: theme.colors.light,
          key: key);

  factory EditorButton.editMode(PalThemeData theme, Function onPressed,
          {Key key, bool isEnabled = true}) =>
      EditorButton(
        onPressed: onPressed,
        size: 52,
        isEnabled: isEnabled,
        icon: Icon(Icons.mode_edit, size: 32, color: theme.colors.light),
        bgColor: theme.colors.color3,
        bordered: true,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
          ignoring : !this.isEnabled,
          child: Opacity(
          opacity: this.isEnabled ? 1 : 0.7,
            child: CircleIconButton(
          icon: icon,
          radius: size / 2,
          backgroundColor: bgColor,
          onTapCallback: (onPressed != null) ? () {
            HapticFeedback.selectionClick();

            onPressed();
          } : null,
        ),
      ),
    );
  }
}
