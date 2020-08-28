import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/shared/widgets/circle_button.dart';

class BubbleOverlayButton extends StatefulWidget {
  final double width, height;
  final Size screenSize;
  final Function onTapCallback;

  const BubbleOverlayButton({
    Key key,
    @required this.screenSize,
    this.height = 50.0,
    this.width = 50.0,
    this.onTapCallback,
  }) : super(key: key);

  @override
  _BubbleOverlayButtonState createState() => _BubbleOverlayButtonState();
}

class _BubbleOverlayButtonState extends State<BubbleOverlayButton> {
  Offset _position;

  @override
  void initState() {
    super.initState();
    _position = Offset(
      widget.screenSize.width / 2 - (widget.width / 2),
      widget.screenSize.height - (widget.height * 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_position != null) {
      return Positioned(
        left: _position.dx,
        top: _position.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _position = details.globalPosition -
                  Offset(
                    widget.width / 2,
                    widget.height / 2,
                  );
            });
          },
          child: _buildBubble(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildBubble() {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: CircleIconButton(
        backgroundColor: PalTheme.of(context).floatingBubbleBackgroundColor,
        radius: widget.width / 2,
        shadow: BoxShadow(
          color: Colors.black.withOpacity(0.25),
          spreadRadius: 10,
          blurRadius: 35,
          offset: Offset(0, 3), // changes position of shadow
        ),
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onTapCallback: () {
          HapticFeedback.selectionClick();
          if (widget.onTapCallback != null) {
            widget.onTapCallback();
          }
        },
      ),
    );
  }
}
