import 'package:flutter/material.dart';
import 'package:pal/src/theme.dart';


class PartialOverlayedPage extends StatefulWidget {

  final Widget? child;

  PartialOverlayedPage({this.child, Key? key}) : super(key: key);

  @override
  PartialOverlayedPageState createState() => PartialOverlayedPageState();
}

class PartialOverlayedPageState extends State<PartialOverlayedPage> with SingleTickerProviderStateMixin {

  late AnimationController fadeAnimController;
  late Animation<double> backgroundSizeAnimation;

  @override
  void initState() {
    fadeAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    backgroundSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(0, 1, curve: Curves.easeInOut),
    );
    super.initState();
    fadeAnimController.forward();
  }

  Future closePage() async {
    await fadeAnimController.reverse();
  }

  @override
  void dispose() {
    fadeAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      color: Colors.black54,
      child: AnimatedBuilder(
        animation: backgroundSizeAnimation,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, size.height - (size.height * backgroundSizeAnimation.value)),
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 4 / 5,
            widthFactor: 1,
            child: child,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: PalTheme.of(context)!.colors.light,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0)
            )
          ),
          child: widget.child
        ),
      ),
    );
  }

}