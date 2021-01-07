import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class PreviewCard {
  final String previewImage;
  final String title;
  final String description;
  bool isSelected;

  PreviewCard(
    this.previewImage,
    this.title,
    this.description, {
    this.isSelected = false,
  });
}

class PreviewCardWidget extends StatefulWidget {
  final PreviewCard cardData;
  final int index;
  final Function(int) onTap;

  const PreviewCardWidget({
    Key key,
    @required this.cardData,
    this.index,
    this.onTap,
  }) : super(key: key);

  @override
  _PreviewCardWidgetState createState() => _PreviewCardWidgetState();
}

class _PreviewCardWidgetState extends State<PreviewCardWidget>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      key: ValueKey('pal_PreviewCard_${widget.index}'),
      onTap: () => widget.onTap?.call(widget.index),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: (widget.cardData.isSelected)
              ? BorderSide(
                  color: PalTheme.of(context).colors.color1,
                  width: 6.0,
                )
              : BorderSide.none,
        ),
        elevation: 15,
        child: Stack(
          children: [
            if (widget.cardData.isSelected) _buildCheckbox(),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 35.0,
                    ),
                    child: Image.asset(widget.cardData.previewImage, package: 'pal'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 30.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cardData.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        widget.cardData.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildCheckbox() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(25.0),
            bottomLeft: const Radius.circular(25.0),
          ),
          color: PalTheme.of(context).colors.color1,
        ),
        child: Center(
          child: Icon(
            Icons.check,
            key: ValueKey('pal_PreviewCard_Check_${widget.index}'),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
