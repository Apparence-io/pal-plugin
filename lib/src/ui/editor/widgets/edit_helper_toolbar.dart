import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

class ToolbarAction {
  final Key key;
  final Function onTap;
  final IconData icon;

  ToolbarAction(
    this.key,
    this.onTap,
    this.icon,
  );
}

class EditHelperToolbar extends StatelessWidget {
  final Function onChangeTextFont;
  final Function onChangeTextColor;
  final Function onChangeBorder;
  final Function onCloseTap;
  final num bottomPadding;
  final List<ToolbarAction> extraActions;

  final _toolbarHeight = 40.0;
  final _iconsRadius = 25.0;

  const EditHelperToolbar({
    Key key,
    this.onChangeTextFont,
    this.onChangeTextColor,
    this.onChangeBorder,
    this.onCloseTap,
    this.bottomPadding = 8.0,
    this.extraActions,
  }) : super(key: key);

  factory EditHelperToolbar.text({
    Key key,
    Function onChangeTextFont,
    Function onChangeTextColor,
    Function onClose,
    List<ToolbarAction> extraActions,
    num bottomPadding = 8.0,
  }) {
    return EditHelperToolbar(
      onChangeTextFont: onChangeTextFont,
      onChangeTextColor: onChangeTextColor,
      onCloseTap: onClose,
      bottomPadding: bottomPadding,
      extraActions: extraActions,
    );
  }

  factory EditHelperToolbar.border({
    Key key,
    Function onChangeTextFont,
    Function onChangeTextColor,
    Function onChangeBorder,
    Function onClose,
    num bottomPadding = 8.0,
  }) {
    return EditHelperToolbar(
        onChangeTextFont: onChangeTextFont,
        onChangeTextColor: onChangeTextColor,
        onCloseTap: onClose,
        bottomPadding: bottomPadding,
        extraActions: [
          ToolbarAction(
            ValueKey('pal_EditHelperToolbar_ChangeBorder'),
            onChangeBorder,
            Icons.border_outer,
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        key: ValueKey('pal_EditHelperToolbar'),
        height: _toolbarHeight,
        color: PalTheme.of(context).toolbarBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: [
                      CircleIconButton(
                        key: ValueKey('pal_EditHelperToolbar_TextColor'),
                        radius: _toolbarHeight / 2,
                        backgroundColor: Colors.transparent,
                        onTapCallback: () {
                          HapticFeedback.selectionClick();

                          if (onChangeTextColor != null) {
                            onChangeTextColor();
                          }
                        },
                        icon: Icon(
                          Icons.format_color_text,
                          color: Colors.white,
                          size: _iconsRadius,
                        ),
                      ),
                      CircleIconButton(
                        key: ValueKey('pal_EditHelperToolbar_TextFont'),
                        radius: _toolbarHeight / 2,
                        backgroundColor: Colors.transparent,
                        onTapCallback: () {
                          HapticFeedback.selectionClick();

                          if (onChangeTextFont != null) {
                            onChangeTextFont();
                          }
                        },
                        icon: Icon(
                          Icons.font_download,
                          color: Colors.white,
                          size: _iconsRadius,
                        ),
                      ),
                      if (extraActions != null && extraActions.length > 0)
                        Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: _buildExtraActions(),
                        ),
                      // TODO: Create factory to add some extra actions like border
                    ],
                  ),
                ),
              ),
              CircleIconButton(
                key: ValueKey('pal_EditHelperToolbar_Close'),
                radius: _toolbarHeight / 2,
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
                  size: _iconsRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExtraActions() {
    List<Widget> children = [];
    for (final ToolbarAction action in extraActions) {
      children.add(
        CircleIconButton(
          key: action.key,
          radius: _toolbarHeight / 2,
          backgroundColor: Colors.transparent,
          onTapCallback: () {
            HapticFeedback.selectionClick();

            if (action.onTap != null) {
              action.onTap();
            }
          },
          icon: Icon(
            action.icon,
            color: Colors.white,
            size: _iconsRadius,
          ),
        ),
      );
    }
    return children;
  }
}
