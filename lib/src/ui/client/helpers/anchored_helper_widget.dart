import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pal/src/ui/shared/utilities/element_finder.dart';


class AnchoredHelper extends StatefulWidget {

  final BuildContext subPageContext;

  final String keySearch;

  AnchoredHelper(this.subPageContext, this.keySearch);

  @override
  _AnchoredHelperState createState() => _AnchoredHelperState();
}

class _AnchoredHelperState extends State<AnchoredHelper> {

  Offset currentPos;

  Size anchorSize;

  Rect writeArea;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ElementFinder elementFinder = ElementFinder(widget.subPageContext);
      var element = elementFinder.searchChildElement(widget.keySearch);
      setState(() {
        anchorSize = element.bounds.size;
        currentPos = element.offset;
        writeArea = elementFinder.getLargestAvailableSpace(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Visibility(
              visible: this.currentPos != null,
              child: SizedBox(
                child: CustomPaint(
                  painter: AnchoredFullscreenPainter(
                    currentPos: this.currentPos,
                    anchorSize: this.anchorSize,
                    padding: 16
                  )
                )
              ),
            )
          ),
          Positioned.fromRect(
            rect: writeArea ?? Rect.largest,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "This is a text i wanna show. My user needs to understand this part of the screen",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21
                    ),
                  ),
                ),
                _buildPositivFeedback(),
                _buildNegativFeedback(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNegativFeedback() {
    return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: InkWell(
          key: ValueKey("negativeFeedback"),
          child: Text(
            "This is not helping",
            style: TextStyle(
              // color: widget.textColor, fontSize: 10
            ),
            textAlign: TextAlign.center,
          ),
          // onTap: this.widget.onTrigger,
        ),
    );
  }

  Widget _buildPositivFeedback() {
    return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: InkWell(
          key: ValueKey("positiveFeedback"),
          child: Text(
            "Ok, thanks !",
            style: TextStyle(
              // color: widget.textColor,
              fontSize: 18,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.center,
          ),
          // onTap: this.widget.onTrigger,
        ),
    );
  }
}

class AnimatedAnchoredFullscreenCircle extends AnimatedWidget {

  final Offset currentPos;
  final double padding;
  final Size anchorSize;
  final Color bgColor;

  final Animation<double> _stroke1Animation, _stroke2Animation;

  Animation<double> get _progress => this.listenable;

  AnimatedAnchoredFullscreenCircle({
    @required this.currentPos,
    @required this.padding,
    @required this.bgColor,
    @required this.anchorSize,
    @required Listenable listenable
  }) : _stroke1Animation = new CurvedAnimation(
        parent: listenable,
        curve: Curves.ease
      ),
      _stroke2Animation = CurvedAnimation(
        parent: listenable,
        curve: Interval(0, .8, curve: Curves.ease),
      ),
      super(listenable: listenable);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomPaint(
        painter: AnchoredFullscreenPainter(
          currentPos: currentPos,
          anchorSize: anchorSize,
          padding: padding,
          bgColor: bgColor,
          circle1Width: _stroke1Animation.value * 88,
          circle2Width: _stroke2Animation.value * 140,
        )
      )
    );
  }
}


class AnchoredFullscreenPainter extends CustomPainter {

  final Offset currentPos;

  final double padding;

  final Size anchorSize;

  final double area = 24.0 * 24.0;

  final Color bgColor;

  double circle1Width, circle2Width;

  AnchoredFullscreenPainter({
    this.currentPos,
    this.anchorSize,
    this.padding = 0,
    this.bgColor,
    this.circle1Width = 64,
    this.circle2Width = 100,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint clearPainter = Paint()
      ..blendMode = BlendMode.clear
      ..isAntiAlias = true;
    Paint bgPainter = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    Paint circle1Painter = Paint()
      ..color = Colors.white.withOpacity(.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circle1Width
      ..isAntiAlias = true;
    Paint circle2Painter = Paint()
      ..color = Colors.white.withOpacity(.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circle2Width
      ..isAntiAlias = true;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPainter);
    // canvas.drawCircle(currentPos, radius, clearPainter);
    // canvas.drawRect(currentPos & anchorSize, clearPainter);
    var radius = sqrt(pow(anchorSize.width, 2) + pow(anchorSize.height, 2)) / 2;
    var center = currentPos.translate(anchorSize.width / 2, anchorSize.height / 2);
    canvas.drawCircle(center, radius + padding, circle1Painter);
    canvas.drawCircle(center, radius + padding, circle2Painter);
    canvas.drawCircle(center, radius + padding, clearPainter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(AnchoredFullscreenPainter oldDelegate) {
    return oldDelegate.currentPos != currentPos
      || oldDelegate.circle1Width != circle1Width
      || oldDelegate.circle2Width != circle2Width;
  }

  @override
  bool hitTest(Offset position) {
    if(currentPos == null)
      return false;
    var distance = (position - currentPos).distanceSquared;
    if(distance <= area) {
      return true;
    }
    return false;
  }
}