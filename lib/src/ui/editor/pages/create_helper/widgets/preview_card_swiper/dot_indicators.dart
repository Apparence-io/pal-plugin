import 'package:flutter/widgets.dart';
import 'package:pal/src/theme.dart';

class DotIndicatorsWidget extends StatelessWidget {
  final int pagesCount;
  final int activePage;
  const DotIndicatorsWidget({
    Key? key,
    required this.pagesCount,
    required this.activePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      runSpacing: 5.0,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _buildDots(context),
    );
  }

  List<Widget> _buildDots(BuildContext context) {
    List<Widget> dots = [];
    for (int i = 0; i < pagesCount; i++) {
      Widget dot = activePage == i
          ? _buildActiveDot(context)
          : _buildDisabledDot(context);
      dots.add(dot);
    }
    return dots;
  }

  Widget _buildActiveDot(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: PalTheme.of(context)!.colors.dark,
      ),
    );
  }

  Widget _buildDisabledDot(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: PalTheme.of(context)!.colors.dark!.withAlpha(50),
      ),
    );
  }
}
