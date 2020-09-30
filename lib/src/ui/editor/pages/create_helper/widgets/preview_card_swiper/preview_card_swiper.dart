import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/dot_indicators.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card.dart';

class PreviewCardSwiperWidget extends StatefulWidget {
  final List<PreviewCard> cards;
  final String note;
  final Function(int) onCardSelected;

  PreviewCardSwiperWidget({
    Key key,
    @required this.cards,
    this.note,
    this.onCardSelected,
  }) : super(key: key);

  @override
  _PreviewCardSwiperWidgetState createState() =>
      _PreviewCardSwiperWidgetState();
}

class _PreviewCardSwiperWidgetState extends State<PreviewCardSwiperWidget>
    with SingleTickerProviderStateMixin {
  PageController _controller;
  int _currentpage = 0;

  @override
  initState() {
    super.initState();
    _controller = PageController(
      initialPage: _currentpage,
      viewportFraction: 0.8,
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (widget.note != null)
          Text(
            widget.note,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: PalTheme.of(context).colors.color1,
              fontSize: 10,
            ),
          ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                PageView.builder(
                  key: ValueKey('pal_PreviewCardSwiperWidget_PageView'),
                  controller: _controller,
                  itemCount: widget.cards.length,
                  onPageChanged: _onPageViewChange,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildPreviewCard(
                      context,
                      index,
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: DotIndicatorsWidget(
                    activePage: _currentpage,
                    pagesCount: widget.cards.length,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  void _onPageViewChange(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _currentpage = index;
    });
  }

  Widget _buildPreviewCard(
    BuildContext context,
    int index,
  ) {
    PreviewCard cardData = widget.cards[index];

    return Padding(
      padding: EdgeInsets.only(
        left: 9.0,
        right: 9.0,
        top: 10.0,
        bottom: 50.0,
      ),
      child: PreviewCardWidget(
        index: index,
        cardData: cardData,
        onTap: _onCardTap,
      ),
    );
  }

  void _onCardTap(int index) {
    int i = 0;
    for (PreviewCard cardData in widget.cards) {
      if (index == i++) {
        cardData.isSelected = !cardData.isSelected;
      } else {
        cardData.isSelected = false;
      }
    }
    this.setState(() {});

    if (widget.onCardSelected != null) {
      widget.onCardSelected(index);
    }
  }
}
