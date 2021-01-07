import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BouncingWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration duration;
  final bool vibrationEnabled;

  BouncingWidget({
    Key key,
    @required this.child,
    @required this.onTap,
    this.vibrationEnabled = true,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  _BouncingWidgetState createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _scale;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return IgnorePointer(
      ignoring: widget.onTap == null,
      child: Opacity(
        opacity: (widget.onTap != null) ? 1.0 : 0.3,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Transform.scale(
            scale: _scale,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    if (widget.vibrationEnabled) {
      HapticFeedback.selectionClick();
    }
    _controller.forward();
  }

  _onTapUp(TapUpDetails details) {
    Future.delayed(widget.duration, () {
      _controller.reverse();
    });

    widget.onTap?.call();
  }

  _onTapCancel() {
    _controller.reverse();
  }
}
