import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';


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
      elementFinder.searchChildElement(widget.keySearch);
      setState(() {
        anchorSize = elementFinder.result.size;
        currentPos = elementFinder.getResultCenter();
        writeArea = elementFinder.getLargestAvailableSpace();
        print("writeArea: $writeArea");
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
                    anchorSize: this.anchorSize
                  )
                )
              ),
            )
          ),
          Positioned.fromRect(
            rect: writeArea ?? Rect.largest,
            child: Center(child: Text("This is a text i wanna show")),
          )
        ],
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
    Paint redPainter = Paint()
      ..color = Colors.redAccent
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
    canvas.drawCircle(Offset(0,0), 60, redPainter);
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