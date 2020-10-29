import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/simple_helper.dart';

class SimpleHelperLayout extends StatefulWidget {
  final SimpleHelperPage toaster;
  final DismissDirectionCallback onDismissed;

  SimpleHelperLayout({this.toaster, this.onDismissed, Key key})
      : super(key: key);

  @override
  SimpleHelperLayoutState createState() => SimpleHelperLayoutState();
}

class SimpleHelperLayoutState extends State<SimpleHelperLayout>
    with SingleTickerProviderStateMixin {
  // Offset firstEventPosition;
  // Tween<double> _blurTween = Tween(begin: 0.0, end: 4.0);
  // Tween<double> _opacityTween = Tween(begin: 0.0, end: 1.0);
  // Animation<double> _blurAnimation;
  // Animation<double> _opacityAnimation;
  // AnimationController _controller;
  // bool _isDismissibleVisible = true;

  final double padding = 32;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 1300),
    // );

    // _blurAnimation = _blurTween.animate(_controller)
    //   ..addListener(
    //     () {
    //       setState(() {});
    //     },
    //   );
    // _opacityAnimation = _opacityTween.animate(_controller)
    //   ..addListener(
    //     () {
    //       setState(() {});
    //     },
    //   );

    // _controller.forward();
  }

  reverseAnimations() async {
    // Remove dismissible from tree before calling setState
    // _isDismissibleVisible = false;
    // _controller.reverse();
    // await Future.delayed(Duration(milliseconds: 2300));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          // BackdropFilter(
          //   filter: ImageFilter.blur(
          //     sigmaX: _blurAnimation.value,
          //     sigmaY: _blurAnimation.value,
          //   ),
          //   child: Opacity(
          //     opacity: _opacityAnimation.value,
          //     child: Container(
          //       color: Colors.black26,
          //     ),
          //   ),
          // ),
          // if (_isDismissibleVisible)
          Positioned(
            bottom: padding,
            left: padding,
            right: padding,
            child: _buildToaster(),
          ),
          // Positioned.fill(
          //     child: Center(
          //   child: _buildOnDismissFeedback(),
          // ))
        ],
      ),
    );
  }

  // AnimatedBuilder _buildOnDismissFeedback() {
  //   return AnimatedBuilder(
  //     animation: _opacityIconAnimation,
  //     builder: (context, child) {
  //       return Transform.scale(
  //         scale: sin(_opacityIconAnimation.value * pi),
  //         child: Opacity(
  //           opacity: sin(_opacityIconAnimation.value * pi),
  //           child: child,
  //         ),
  //       );
  //     },
  //     child: Icon(Icons.thumb_up, size: 200),
  //   );
  // }

  Widget _buildToaster() {
    return Material(
      type: MaterialType.canvas,
      elevation: 0,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Dismissible(
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
      ),
    );
  }
}
