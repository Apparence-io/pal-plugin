import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/editor/widgets/progress_widget/pulsing_circle.dart';

import 'progress_bar.dart';

/* Controller class : Takes all the variables needed, and transformes them before rendering */
class ProgressBarWidget extends StatefulWidget {
  final double nbSteps;
  final ValueNotifier<int> step;

  const ProgressBarWidget({Key key, this.nbSteps, this.step}) : super(key: key);

  @override
  _ProgressBarWidgetState createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget>
    with SingleTickerProviderStateMixin {
  // CORE ATTRIBUTES
  AnimationController controller;
  Animation animation;

  // STATE ATTRIBUTES
  double prevStep;

  // STEPS VARIABLES
  double _stepScale;

  @override
  void initState() {
    // SETUP
    // LISTENING TO STEP CHANGES
    widget.step.addListener(this.refresh);
    // INITIALIZING STEP SIZE : Bringing them to a smaller scale from 0 to 1*
    this._stepScale = 1 / (widget.nbSteps - 1);

    // CONTROLLER AND ANIMATION INIT
    this.controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // ANIMATES THE PROGRESS BAR FROM [STEP-1] TO [STEP]
    this.animation =
        Tween<double>(begin: 0, end: this._stepScale * widget.step.value)
            .animate(this.controller);
    this.prevStep = widget.step.value.toDouble();
    // ANIMATES
    this.controller.forward();
    super.initState();
  }

  void refresh() {
    this.controller.reset();
    // CREATES NEW ANIMATION FROM NEW VALUES
    this.animation = Tween<double>(
            begin: this._stepScale * this.prevStep,
            end: this._stepScale * widget.step.value)
        .animate(this.controller);
    this.prevStep = widget.step.value.toDouble();
    setState(() {
      this.controller.forward();
    });
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
      height: 25,

      // PLACING PULSING CIRCLES ON-TOP THE PROGRESS BAR
      child: Stack(
        children: [
          // PROGRESS BAR
          Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: this.controller,
              builder: (context, child) => ProgressBarRender(
                value: this.animation.value,
                key: ValueKey("ProgressBar"),
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
                    child: PulsingCircleWidget(
                      active: i == widget.step.value,
                      done: i < widget.step.value,
                      key: ValueKey("PulsingCircle"),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
