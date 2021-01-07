import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditorActionItem extends StatefulWidget {
  final Icon icon;
  final String text;
  final Function onTap;

  EditorActionItem({
    Key key,
    @required this.icon,
    @required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  _EditorActionItemState createState() => _EditorActionItemState();
}

class _EditorActionItemState extends State<EditorActionItem>
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

  Widget build(BuildContext contexte) {
    _scale = 1 - _animationController.value;

    return Transform.scale(
      scale: _scale,
      child: IgnorePointer(
        ignoring: this.widget.onTap == null,
        child: Opacity(
          opacity: this.widget.onTap != null ? 1 : 0.3,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                this.widget.icon,
                Divider(height: 8),
                Text(
                  this.widget.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    _animationController.forward();
    HapticFeedback.selectionClick();
  }

  _onTapUp(TapUpDetails details) {
    Future.delayed(_duration, () {
      _animationController.reverse();
    });
    HapticFeedback.selectionClick();
    this.widget.onTap?.call();
  }

  _onTapCancel() {
    _animationController.reverse();
  }
}
