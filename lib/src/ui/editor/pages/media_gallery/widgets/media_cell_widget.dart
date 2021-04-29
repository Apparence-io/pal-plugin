import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/theme.dart';

class MediaCellWidget extends StatefulWidget {
  final String id;
  final String? url;
  final bool isSelected;
  final Function()? onTap;

  MediaCellWidget({
    Key? key,
    required this.id,
    required this.url,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  _MediaCellWidgetState createState() => _MediaCellWidgetState();
}

class _MediaCellWidgetState extends State<MediaCellWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late double _scale;
  Duration _duration = Duration(milliseconds: 100);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animationController!.value;

    return GestureDetector(
      key: ValueKey('pal_MediaCellWidget_${widget.id}'),
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scale,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: widget.url!,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: CachedNetworkImageProvider(widget.url!),
                fit: BoxFit.cover),
                border: Border.all(
                  color: PalTheme.of(context)!.colors.color1!,
                  width: 6.0,
                  style: (widget.isSelected)
                      ? BorderStyle.solid
                      : BorderStyle.none,
                ),
              ),
            ),
            if (widget.isSelected) _buildCheckbox()
          ],
        ),
      ),
    );
  }

  _buildCheckbox() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(10.0),
          ),
          color: PalTheme.of(context)!.colors.color1,
        ),
        child: Center(
          child: Icon(
            Icons.check,
            key: ValueKey('pal_MediaCellWidget_${widget.id}'),
            color: Colors.white,
            size: 15,
          ),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    _animationController!.forward();
    HapticFeedback.selectionClick();
  }

  _onTapUp(TapUpDetails details) {
    Future.delayed(_duration, () {
      _animationController!.reverse();
    });
    widget.onTap!();
  }

  _onTapCancel() {
    _animationController!.reverse();
  }
}
