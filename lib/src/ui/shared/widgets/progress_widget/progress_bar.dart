
import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';

import 'pulsing_circle.dart';

class ProgressWidget extends StatefulWidget {
  final double nbSteps;
  final double step;

  const ProgressWidget({Key key, this.nbSteps, this.step}) : super(key: key);

  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget>
    with SingleTickerProviderStateMixin {
  // CORE ATTRIBUTES
  AnimationController controller;
  Animation animation;

  // STEPS VARIABLES
  double _nbSteps;

  @override
  void initState() {
    // SETUP
    // INITIALIZING STEPS : Bringing them to a smaller scale from 0 to 1*
    this._nbSteps = 1/(widget.nbSteps-1);

    // CONTROLLER AND ANIMATION INIT
    this.controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    // ANIMATES THE PROGRESS BAR FROM [STEP-1] TO [STEP]
    this.animation = Tween<double>(begin: 0, end: this._nbSteps*widget.step).animate(this.controller);
    // ANIMATES
    this.controller.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(ProgressWidget oldWidget) {
    // ONLY TRIGGERS WHEN ATTRIBUTES ARE CHANGED
    if (oldWidget.step != widget.step) {
      this.controller.reset();
      // CREATES NEW ANIMATION FROM NEW VALUES
      this.animation = Tween<double>(begin: this._nbSteps*(widget.step-1), end: this._nbSteps*widget.step).animate(this.controller);
      this.controller.forward();
      super.didUpdateWidget(oldWidget);
    }
  }

  @override
  void dispose() {
    this.controller.stop();
    this.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: ValueKey("ProgressBar"),
      height: 25,

        // PLACING PULSING CIRCLES ON-TOP THE PROGRESS BAR
        child: Stack(

        children: [
          // PROGRESS BAR
          Align(
            alignment: Alignment.center,

            child: FractionallySizedBox(
              widthFactor: 0.9,

              child: AnimatedBuilder(
                animation: this.controller,

                builder: (context, child) => 
                DecoratedBox(
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    //* ANIMATION MOVES THE LEFT GRADIENT COLOR
                    stops: [this.animation.value, 0],
                    // IN THE ORDER BELOW : DARK / GREY
                    colors: [PalTheme.of(context).colors.dark,Color(0xFFC1BFD6)]),
                  ),
                  child: child),

                // SETUPS THE BAR HEIGHT
                child: Container(
                  height: 4,
                ),
              ),
            ),
          ),

          // PUSLING CIRCLES
          Align(
            alignment: Alignment.center,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              // CREATES AS MANY PUSLING CIRCLES AS THERE OF STEPS
              children: [
              for (var i = 0; i < widget.nbSteps; i++)
                // CONTAINER NEEDED TO CREATE AN ALLOCATED SPACE FOR CIRCLE TU PULSE WITHOUR MOVING OTHERS
                Container(
                  width: 25,

                  child: PulsingCircle(active: i==widget.step,done: i<widget.step,key: ValueKey("PulsingCircle"),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

