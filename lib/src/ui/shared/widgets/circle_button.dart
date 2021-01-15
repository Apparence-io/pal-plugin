import 'package:flutter/material.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

// TODO: COnvert to stateless
class CircleIconButton extends StatefulWidget {
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
  final Widget animatedIcon;

  const CircleIconButton({
    Key key,
    this.backgroundColor = Colors.blue,
    this.loadingColor = Colors.white,
    this.splashColor,
    this.radius = 20.0,
    this.shadow,
    this.displayShadow = true,
    this.animatedIcon,
    this.icon,
    this.isLoading = false,
    this.onTapCallback,
    this.borderSide,
  }) : super(key: key);

  factory CircleIconButton.animatedIcon({
    Key key,
    @required AnimatedIcon animatedIcon,
    Color backgroundColor = Colors.blue,
    Color splashColor,
    Color loadingColor = Colors.white,
    num radius = 20.0,
    BoxShadow shadow,
    bool displayShadow = true,
    Function onTapCallback,
    bool isLoading = false,
    BorderSide borderSide,
  }) {
    return CircleIconButton(
      key: key,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      loadingColor: loadingColor,
      radius: radius,
      shadow: shadow,
      displayShadow: displayShadow,
      onTapCallback: onTapCallback,
      isLoading: isLoading,
      borderSide: borderSide,
      animatedIcon: animatedIcon,
    );
  }

  factory CircleIconButton.icon({
    Key key,
    @required final Icon icon,
    Color backgroundColor = Colors.blue,
    Color splashColor,
    Color loadingColor = Colors.white,
    num radius = 20.0,
    BoxShadow shadow,
    bool displayShadow = true,
    Function onTapCallback,
    bool isLoading = false,
    BorderSide borderSide,
  }) {
    return CircleIconButton(
      key: key,
      backgroundColor: backgroundColor,
      icon: icon,
      splashColor: splashColor,
      loadingColor: loadingColor,
      radius: radius,
      shadow: shadow,
      displayShadow: displayShadow,
      onTapCallback: onTapCallback,
      isLoading: isLoading,
      borderSide: borderSide,
    );
  }

  @override
  _CircleIconButtonState createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<CircleIconButton> {
  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onTap: widget.onTapCallback,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: this.widget.borderSide != null
              ? Border.fromBorderSide(this.widget.borderSide)
              : null,
          color: Colors.transparent,
          boxShadow: widget.displayShadow
              ? [
                  widget.shadow ??
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            widget.onTapCallback != null ? 0.1 : 0.03),
                        spreadRadius: 5,
                        blurRadius: 9,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                ]
              : null,
        ),
        child: ClipOval(
          child: Material(
            color: widget.backgroundColor,
            child: SizedBox(
              width: widget.radius * 2,
              height: widget.radius * 2,
              child: (widget.isLoading)
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(
                        backgroundColor: widget.loadingColor,
                        strokeWidth: 2.0,
                      ),
                    )
                  : Center(child: _buildIcon()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() =>
      (widget.icon != null) ? widget.icon : widget.animatedIcon;
}
