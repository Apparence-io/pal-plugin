import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color splashColor;
  final num radius;
  final Icon icon;
  final BoxShadow shadow;
  final Function onTapCallback;
  const CircleIconButton({
    Key key,
    this.backgroundColor = Colors.blue,
    this.splashColor,
    this.radius = 20.0,
    this.shadow,
    @required this.icon,
    this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: [
          shadow ?? BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 9,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipOval(
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
      ),
    );
  }
}
