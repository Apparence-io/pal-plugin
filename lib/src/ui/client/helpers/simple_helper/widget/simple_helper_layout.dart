import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/simple_helper.dart';

class SimpleHelperLayout extends StatefulWidget {
  final SimpleHelperPage toaster;

  final DismissDirectionCallback onDismissed;

  SimpleHelperLayout({this.toaster, this.onDismissed});

  @override
  _SimpleHelperLayoutState createState() => _SimpleHelperLayoutState();
}

class _SimpleHelperLayoutState extends State<SimpleHelperLayout>
    with SingleTickerProviderStateMixin {
  Offset firstEventPosition;

  AnimationController _controllerAnim;

  Animation<double> _opacityIconAnimation;

  final double padding = 32;

  @override
  void initState() {
    _controllerAnim = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _opacityIconAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _controllerAnim,
            curve: Interval(0.0, 0.9, curve: Curves.slowMiddle)));
    super.initState();
  }

  @override
  void dispose() {
    _controllerAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      elevation: 0,
      color: Colors.transparent,
//      color: Colors.black.withOpacity(_opacityExitPageAnimation.value),
      shadowColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: padding,
            left: padding,
            right: padding,
            child: _buildToaster(),
          ),
          Positioned.fill(
              child: Center(
            child: _buildOnDismissFeedback(),
          ))
        ],
      ),
    );
  }

  AnimatedBuilder _buildOnDismissFeedback() {
    return AnimatedBuilder(
      animation: _opacityIconAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: sin(_opacityIconAnimation.value * pi),
          child: Opacity(
            opacity: sin(_opacityIconAnimation.value * pi),
            child: child,
          ),
        );
      },
      child: Icon(Icons.thumb_up, size: 200),
    );
  }

  Widget _buildToaster() {
    return Dismissible(
      key: ValueKey("toaster"),
      child: widget.toaster,
      onDismissed: (DismissDirection direction) {
        if (widget.onDismissed != null) {
          switch (direction) {
            case DismissDirection.startToEnd:
              HapticFeedback.heavyImpact();
              break;
            case DismissDirection.endToStart:
              HapticFeedback.heavyImpact();
              break;
            default:
          }

          widget.onDismissed(direction);
        }
      },
    );
  }
}
