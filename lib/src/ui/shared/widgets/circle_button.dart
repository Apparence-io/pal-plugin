import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color splashColor;
  final num radius;
  final Icon icon;
  final BoxShadow shadow;
  final bool displayShadow;
  final Function onTapCallback;
  const CircleIconButton({
    Key key,
    this.backgroundColor = Colors.blue,
    this.splashColor,
    this.radius = 20.0,
    this.shadow,
    this.displayShadow = true,
    @required this.icon,
    this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: displayShadow ? [
          shadow ??
              BoxShadow(
                color: Colors.black.withOpacity(onTapCallback != null ? 0.1 : 0.03),
                spreadRadius: 5,
                blurRadius: 9,
                offset: Offset(0, 3), // changes position of shadow
              ),
        ] : null,
      ),
      child: ClipOval(
        child: Opacity(
          opacity: onTapCallback != null ? 1 : 0.35,
          child: Material(
            color: backgroundColor,
            child: InkWell(
              splashColor: splashColor,
              child: SizedBox(
                width: radius * 2,
                height: radius * 2,
                child: icon,
              ),
              onTap: onTapCallback,
            ),
          ),
        ),
      ),
    );
  }
}
