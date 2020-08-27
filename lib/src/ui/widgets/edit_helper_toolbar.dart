import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/widgets/circle_button.dart';

class EditHelperToolbar extends StatelessWidget {
  final Function onEditTextTap;
  final Function onChangeBorderTap;
  final Function onChangeFontTap;
  final Function onCloseTap;

  const EditHelperToolbar({
    Key key,
    this.onEditTextTap,
    this.onChangeBorderTap,
    this.onChangeFontTap,
    this.onCloseTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const toolbarHeight = 25.0;
    const iconsRadius = 18.0;

    return Container(
      height: toolbarHeight,
      color: PalTheme.of(context).toolbarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleIconButton(
                  radius: toolbarHeight / 2,
                  backgroundColor: Colors.transparent,
                  onTapCallback: () {
                    HapticFeedback.selectionClick();

                    if (onEditTextTap != null) {
                      onEditTextTap();
                    }
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: iconsRadius,
                  ),
                ),
                CircleIconButton(
                  radius: toolbarHeight / 2,
                  backgroundColor: Colors.transparent,
                  onTapCallback: () {
                    HapticFeedback.selectionClick();

                    if (onChangeBorderTap != null) {
                      onChangeBorderTap();
                    }
                  },
                  icon: Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                    size: iconsRadius,
                  ),
                ),
                CircleIconButton(
                  radius: toolbarHeight / 2,
                  backgroundColor: Colors.transparent,
                  onTapCallback: () {
                    HapticFeedback.selectionClick();

                    if (onChangeFontTap != null) {
                      onChangeFontTap();
                    }
                  },
                  icon: Icon(
                    Icons.format_italic,
                    color: Colors.white,
                    size: iconsRadius,
                  ),
                ),
              ],
            ),
            CircleIconButton(
              radius: toolbarHeight / 2,
              backgroundColor: Colors.transparent,
              onTapCallback: () {
                HapticFeedback.selectionClick();

                if (onCloseTap != null) {
                  onCloseTap();
                }
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: iconsRadius,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
