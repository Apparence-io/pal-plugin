import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color splashColor;
  final num radius;
  final Icon icon;
  final Function onTapCallback;
  const CircleIconButton({
    Key key,
    this.backgroundColor = Colors.blue,
    this.splashColor,
    this.radius = 20.0,
    @required this.icon,
    this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: backgroundColor,
        child: InkWell(
          splashColor: splashColor,
          child: SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: icon,
          ),
          onTap: () {
            if (onTapCallback != null) {
              onTapCallback();
            }
          },
        ),
      ),
    );
  }
}
