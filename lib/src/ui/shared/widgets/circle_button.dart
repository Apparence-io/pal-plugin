import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color splashColor;
  final Color loadingColor;
  final num radius;
  final Icon icon;
  final BoxShadow shadow;
  final bool displayShadow;
  final Function onTapCallback;
  final bool isLoading;
  final BorderSide borderSide;

  const CircleIconButton(
      {Key key,
      this.backgroundColor = Colors.blue,
      this.loadingColor = Colors.white,
      this.splashColor,
      this.radius = 20.0,
      this.shadow,
      this.displayShadow = true,
      @required this.icon,
      this.isLoading = false,
      this.onTapCallback,
      this.borderSide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: (onTapCallback == null),
      child: Opacity(
        opacity: (onTapCallback != null) ? 1 : 0.40,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: this.borderSide != null
                ? Border.fromBorderSide(this.borderSide)
                : null,
            color: Colors.transparent,
            boxShadow: displayShadow
                ? [
                    shadow ??
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(onTapCallback != null ? 0.1 : 0.03),
                          spreadRadius: 5,
                          blurRadius: 9,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                  ]
                : null,
          ),
          child: ClipOval(
            child: Material(
              color: backgroundColor,
              child: InkWell(
                splashColor: splashColor,
                child: SizedBox(
                  width: radius * 2,
                  height: radius * 2,
                  child: (isLoading)
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(
                            backgroundColor: loadingColor,
                            strokeWidth: 2.0,
                          ),
                        )
                      : icon,
                ),
                onTap: onTapCallback,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
