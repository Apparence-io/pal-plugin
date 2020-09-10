import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';


class AnchoredHelper extends StatefulWidget {

  final BuildContext subPageContext;

  AnchoredHelper(this.subPageContext);

  @override
  _AnchoredHelperState createState() => _AnchoredHelperState();
}

class _AnchoredHelperState extends State<AnchoredHelper> {

  Offset currentPos;

  Size anchorSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ElementFinder elementFinder = ElementFinder(widget.subPageContext);
      elementFinder.searchChildElement("childRoute2Push");
      setState(() {
        anchorSize = elementFinder.result.size;
        currentPos = elementFinder.getResultCenter();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        child: Visibility(
          visible: this.currentPos != null,
          child: SizedBox(
            child: CustomPaint(painter: AnchoredFullscreenPainter(
                currentPos: this.currentPos,
                anchorSize: this.anchorSize
              )
            )
          ),
        ),
      ),
    );
  }
}


class AnchoredFullscreenPainter extends CustomPainter {

  Offset currentPos;

  final double radius = 32;

  final Size anchorSize;

  final double area = 24.0 * 24.0;

  AnchoredFullscreenPainter({this.currentPos, this.anchorSize});

  @override
  void paint(Canvas canvas, Size size) {
    Paint clearPainter = Paint()
      ..blendMode = BlendMode.clear
      ..isAntiAlias = true;
    Paint bgPainter = Paint()
      ..color = Colors.lightGreenAccent
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPainter);
    // canvas.drawCircle(currentPos, radius, clearPainter);
    // canvas.drawRect(currentPos & anchorSize, clearPainter);
    canvas.drawRect(Rect.fromCenter(
      center: currentPos,
      width: anchorSize.width,
      height: anchorSize.height), clearPainter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(AnchoredFullscreenPainter oldDelegate) {
    return oldDelegate.currentPos != currentPos;
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