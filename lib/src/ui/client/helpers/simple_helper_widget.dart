import 'dart:math';

import 'package:flutter/material.dart';

class ToastLayout extends StatefulWidget {

  final Toaster toaster;

  final DismissDirectionCallback onDismissed;

  ToastLayout({this.toaster, this.onDismissed});

  @override
  _ToastLayoutState createState() => _ToastLayoutState();
}

class _ToastLayoutState extends State<ToastLayout> with SingleTickerProviderStateMixin {

  Offset firstEventPosition;

  AnimationController _controllerAnim;

  Animation<double> _opacityIconAnimation;


  final double padding = 32;

  @override
  void initState() {
    _controllerAnim = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _opacityIconAnimation = Tween<double>(begin: 0, end: 1)
      .animate(
      CurvedAnimation(
        parent: _controllerAnim,
        curve: Interval(0.0, 0.9, curve: Curves.slowMiddle)
      )
    );
    super.initState();
  }

  @override
  void dispose() {
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
            )
          )
        ],
      ),
    );
  }

  AnimatedBuilder _buildOnDismissFeedback() {
    return AnimatedBuilder(
      animation: _opacityIconAnimation,
      builder: (context,child) {
        return Transform.scale(
          scale: sin(_opacityIconAnimation.value * pi),
          child: Opacity(
            opacity: sin(_opacityIconAnimation.value * pi) ,
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
        onDismissed: widget.onDismissed,
    );
  }
}


class Toaster extends StatefulWidget {

  final String title, description;

  Toaster({Key key, this.title, this.description}) : super(key: key);

  @override
  _ToasterState createState() => _ToasterState();
}

class _ToasterState extends State<Toaster> with SingleTickerProviderStateMixin {

  AnimationController _controllerAnim;

  @override
  void initState() {
    super.initState();
    _controllerAnim = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controllerAnim.stop();
    _controllerAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 8), blurRadius: 8, spreadRadius: 2)
        ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildLeft(),
            _buildContent(),
            _buildRight(),
          ],
        ),
      ),
    );
  }

  Flexible _buildLeft() {
    return Flexible(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height:16),
          AnimatedBuilder(
            animation: _controllerAnim,
            builder: (context, child) => Transform.scale(
              scale: sin(_controllerAnim.value) * pi/2,
              child: child,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4,16,8,0),
            child: Icon(Icons.thumb_down, color: Colors.white, size: 14,),
          )
        ],
      ),
    );
  }

  Flexible _buildRight() {
    return Flexible(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(height: 16),
          AnimatedBuilder(
            animation: _controllerAnim,
            builder: (context, child) => Transform.scale(
              scale: sin(_controllerAnim.value) * pi/2,
              child: child,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4,16,8,0),
            child: Icon(Icons.thumb_up, color: Colors.white, size: 14,),
          )
        ],
      ),
    );
  }

  Flexible _buildContent() {
    return Flexible(
      flex: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if(this.widget.title != null)
              Text(this.widget.title, style: TextStyle(color: Colors.white, fontSize: 10),),
            if(this.widget.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(this.widget.description, style: TextStyle(color: Colors.white, fontSize: 14), maxLines: 10,),
              ),
          ],
        ),
      ),
    );
  }
}
