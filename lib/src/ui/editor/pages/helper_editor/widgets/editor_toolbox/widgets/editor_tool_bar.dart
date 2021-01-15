import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

enum ToolBarActionButton {
  text,
  media,
  color,
  font,
  border,
}

enum ToolBarGlobalActionButton {
  backgroundColor,
}

class EditorToolBar extends StatelessWidget {
  final AnimationController drawerAnimation;
  final AnimationController iconsAnimation;

  final List<ToolBarGlobalActionButton> globalActions;
  final List<ToolBarActionButton> editableElementActions;

  final ValueNotifier<bool> isBottomBarVisibleNotifier;

  final Function(ToolBarActionButton) onActionTap;
  final Function(ToolBarGlobalActionButton) onGlobalActionTap;

  const EditorToolBar({
    Key key,
    @required this.globalActions,
    @required this.editableElementActions,
    @required this.isBottomBarVisibleNotifier,
    @required this.drawerAnimation,
    @required this.iconsAnimation,
    this.onActionTap,
    this.onGlobalActionTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: this.drawerAnimation,
      builder: (context, child) => Positioned(
          bottom: 80.0 - (70 * this.drawerAnimation.value),
          right: 30.0,
          child: child),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10.0,
        spacing: 10.0,
        children: [
          // TODO: Create it in parent, then factor to create widget
          ..._buildSpecificItemActions(context),
          (this.editableElementActions != null &&
                  this.editableElementActions.length > 0)
              ? SizedBox(
                  width: 20,
                  child: Divider(
                    color: Colors.white60,
                    thickness: 1.5,
                  ),
                )
              : Container(),
          ..._buildGlobalActions(context),
          SizedBox(
            width: 20,
            child: Divider(
              color: Colors.white60,
              thickness: 1.5,
            ),
          ),

          // /!\ BOTTOM DRAWER ICON /!\
          AnimatedBuilder(
            animation: this.drawerAnimation,
            builder: (context, child) => Transform.rotate(
                angle: -1.5708 * (cos(pi / 2 * this.drawerAnimation.value)),
                child: child),
            child: CircleIconButton.animatedIcon(
              animatedIcon: AnimatedIcon(
                  icon: AnimatedIcons.arrow_menu,
                  color: Colors.white,
                  progress: this.drawerAnimation),
              backgroundColor: PalTheme.of(context).colors.black,
              onTapCallback: () {
                this.isBottomBarVisibleNotifier.value =
                    !this.isBottomBarVisibleNotifier.value;
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSpecificItemActions(BuildContext context) {
    List<Widget> actions = [];
    for (final elementAction in this.editableElementActions) {
      IconData iconData;
      switch (elementAction) {
        case ToolBarActionButton.border:
          iconData = Icons.border_all;
          break;
        case ToolBarActionButton.color:
          iconData = Icons.format_color_text;
          break;
        case ToolBarActionButton.font:
          iconData = Icons.font_download;
          break;
        case ToolBarActionButton.media:
          iconData = Icons.insert_link;
          break;
        case ToolBarActionButton.text:
          iconData = Icons.edit;
          break;
        default:
          iconData = Icons.more_horiz;
      }

      Widget globalActionToAdd = AnimatedBuilder(
        animation: this.iconsAnimation,
        builder: (context, child) =>
            Transform.scale(scale: this.iconsAnimation.value, child: child),
        child: CircleIconButton(
          icon: Icon(
            iconData,
            color: Colors.white,
          ),
          backgroundColor: PalTheme.of(context).colors.dark,
          onTapCallback: () => this.onActionTap(elementAction),
        ),
      );
      actions.add(globalActionToAdd);
    }

    return actions;
  }

  List<Widget> _buildGlobalActions(BuildContext context) {
    List<Widget> actions = [];
    for (final globalAction in this.globalActions) {
      IconData iconData;
      switch (globalAction) {
        case ToolBarGlobalActionButton.backgroundColor:
          iconData = Icons.invert_colors;
          break;
        default:
          iconData = Icons.more_horiz;
      }

      Widget globalActionToAdd = CircleIconButton(
        icon: Icon(
          iconData,
          color: PalTheme.of(context).colors.dark,
        ),
        backgroundColor: PalTheme.of(context).colors.light,
        onTapCallback: () => this.onGlobalActionTap(globalAction),
      );
      actions.add(globalActionToAdd);
    }
    return actions;
  }
}
