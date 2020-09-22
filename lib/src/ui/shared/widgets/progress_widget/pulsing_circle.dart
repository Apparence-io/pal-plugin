import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';

class PulsingCircle extends StatefulWidget {
  final bool active;
  final bool done;

  const PulsingCircle({Key key, this.active, this.done}) : super(key: key);

  @override
  _PulsingCircleState createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<PulsingCircle> with SingleTickerProviderStateMixin{
  // CORE ATTRIBUTES
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // INITIALIZING PULSING ANIMATION
    this.controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // THE ACTIVE CIRCLE IS PULSATING BEETWEEN 8-12 OF RADIUS (16-24)
    this.animation = Tween<double>(begin:8,end:12).animate(this.controller);
    // REPEATS INFINIT
    this.controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    this.controller.stop();
    this.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: this.controller,

        builder: (context, child) =>
         CircleAvatar(
          //  COLOR BASED ON IF THE CIRCLE IS DONE / ACTIVE / NONE
          // IN THE ORDER BELOW : DARK / CYAN / GREY
          backgroundColor: widget.done ? PalTheme.of(context).colors.dark  : widget.active ? PalTheme.of(context).colors.color3 : Color(0xFFC1BFD6) ,
          // IF THE CIRCLE IS ACTIVE : ANIMATED / IF NOT : STATIC
          radius: widget.active ? this.animation.value : 8,
        ),
      );
  }
}