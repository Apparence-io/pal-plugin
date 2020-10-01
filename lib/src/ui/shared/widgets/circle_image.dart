import 'package:flutter/material.dart';

class CircleImageButton extends StatelessWidget {
  final Color backgroundColor;
  final Color splashColor;
  final num radius;
  final String image;
  final BoxShadow shadow;
  const CircleImageButton({
    Key key,
    this.backgroundColor = Colors.blue,
    this.splashColor,
    this.radius = 20.0,
    this.shadow,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: [
          shadow ??
              BoxShadow(
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
          child: SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: Image.asset(image),
          ),
        ),
      ),
    );
  }
}
