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


class AnchoredFullscreenPainter extends CustomPainter {

  final Offset currentPos;

  final double padding;

  final Size anchorSize;

  final double area = 24.0 * 24.0;

  AnchoredFullscreenPainter({this.currentPos, this.anchorSize, this.padding = 0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint clearPainter = Paint()
      ..blendMode = BlendMode.clear
      ..isAntiAlias = true;
    Paint bgPainter = Paint()
      ..color = Colors.lightGreenAccent.withOpacity(.6)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPainter);
    // canvas.drawCircle(currentPos, radius, clearPainter);
    // canvas.drawRect(currentPos & anchorSize, clearPainter);
    if(padding > 0) {
      canvas.drawRect(Rect.fromLTWH(
        currentPos.dx - padding /2,
        currentPos.dy - padding /2,
        anchorSize.width + padding,
        anchorSize.height + padding), clearPainter);
    } else {
      canvas.drawRect(Rect.fromLTWH(
        currentPos.dx,
        currentPos.dy,
        anchorSize.width,
        anchorSize.height), clearPainter);
    }

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