import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _CircleIconButtonState extends State<CircleIconButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double _scale;
  Duration _duration = Duration(milliseconds: 100);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animationController.value;

    return Transform.scale(
      scale: _scale,
      child: IgnorePointer(
        ignoring: (widget.onTapCallback == null),
        child: Opacity(
          opacity: (widget.onTapCallback != null) ? 1 : 0.40,
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
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
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
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() =>
      (widget.icon != null) ? widget.icon : widget.animatedIcon;

  _onTapDown(TapDownDetails details) {
    _animationController.forward();
    HapticFeedback.selectionClick();
  }

  _onTapUp(TapUpDetails details) {
    Future.delayed(_duration, () {
      if(mounted)
        _animationController.reverse();
    });
    widget.onTapCallback?.call();
  }

  _onTapCancel() {
    _animationController.reverse();
  }
}
