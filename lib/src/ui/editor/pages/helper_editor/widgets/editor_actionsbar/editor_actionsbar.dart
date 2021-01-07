import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_actionsbar/widgets/editor_action_item.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

typedef OnCancel();
typedef OnPreview();
typedef OnSettings();
typedef OnText();
typedef OnValidate = Future<void> Function();

// ************ ANIMATION BOUNDS
const double UPPERBOUND = 100;
const double LOWERBOUND = 0;

class EditorActionsBar extends StatefulWidget {
  final Widget child;
  final OnCancel onCancel;
  final OnText onText;
  final OnSettings onSettings;
  final OnPreview onPreview;
  final OnValidate onValidate;
  final GlobalKey scaffoldKey;
  final bool visible;

  EditorActionsBar({
    this.child,
    this.onCancel,
    this.onValidate,
    this.scaffoldKey,
    this.onPreview,
    this.onSettings,
    this.onText,
    this.visible = true,
    Key key,
  }) : super(key: key);

  @override
  _EditorActionsBarState createState() => _EditorActionsBarState();
}

class _EditorActionsBarState extends State<EditorActionsBar>
    with SingleTickerProviderStateMixin {
  final kFloatingRadius = 45.0;
  // ANIMATION CONTROLLER
  AnimationController controller;
  // ANIMATION TARGET : Controller will animate to *animationTarget*, on next cycle
  double animationTarget;

  @override
  void initState() {
    this.animationTarget = UPPERBOUND;
    this.controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      value: 0,
      lowerBound: 0,
      upperBound: 1,
    );
    super.initState();
  }

  @override
  void dispose() { 
    this.controller.dispose();
    super.dispose();
  }

  double _currentControllerValue() => this.controller.value * UPPERBOUND;

  @override
  Widget build(BuildContext context) {
    final kDeg90TRad = 1.5708;

    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(child: widget.child),
          if (widget.visible)
            AnimatedBuilder(
              animation: this.controller,
              builder: (context, child) => Positioned(
                bottom: 110 - _currentControllerValue(),
                right: 20,
                child: Transform.rotate(
                  angle: kDeg90TRad * -(cos(this.controller.value * pi / 2)),
                  child: CircleIconButton.animatedIcon(
                    key: ValueKey('EditorActionBarDrawerButton'),
                    backgroundColor: PalTheme.of(context).colors.color2,
                    animatedIcon: AnimatedIcon(
                      icon: AnimatedIcons.arrow_menu,
                      progress: controller,
                      color: Colors.white,
                      semanticLabel: 'Show menu',
                    ),
                    onTapCallback: () {
                      this.controller.animateTo(
                          this.animationTarget / UPPERBOUND,
                          curve: Curves.easeOut);
                      this.setState(() {
                        this.animationTarget =
                            this.animationTarget == LOWERBOUND
                                ? UPPERBOUND
                                : LOWERBOUND;
                      });
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: widget.visible && this.animationTarget == UPPERBOUND
          ? this._buildSaveFloatingButton(context)
          : null,
      bottomNavigationBar: widget.visible ? this._buildTabItems(context) : null,
    );
  }

// **************************************************** FLOATING BUTTON ****************************************************
  Widget _buildSaveFloatingButton(BuildContext context) {
    return CircleIconButton(
      key: ValueKey('editableActionBarValidateButton'),
      backgroundColor: PalTheme.of(context).colors.color2,
      radius: 40.0,
      borderSide: BorderSide(
        color: Colors.white,
        width: 3,
      ),
      shadow: BoxShadow(
        color: Colors.black.withOpacity(0.15),
        spreadRadius: 4,
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
      icon: Icon(
        Icons.save,
        color: Colors.white,
        size: kFloatingRadius,
      ),
      onTapCallback: widget.onValidate,
    );
  }
// **************************************************** /FLOATING BUTTON\ ****************************************************

// **************************************************** BOTTOM BAR ITEMS ****************************************************
  Widget _buildTabItems(BuildContext context) {
    final kIconColor = Colors.white;
    final kIconSize = 32.0;

    return AnimatedBuilder(
      animation: this.controller,
      builder: (context, child) => Transform.translate(
          offset: Offset(0, _currentControllerValue()), child: child),
      child: BottomAppBar(
        color: PalTheme.of(context).colors.dark,
        shape: null,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    EditorActionItem(
                      key: ValueKey('editableActionBarCancelButton'),
                      icon: Icon(
                        Icons.exit_to_app,
                        color: kIconColor,
                        size: kIconSize,
                      ),
                      text: 'QUIT',
                      onTap: widget.onCancel,
                    ),
                    EditorActionItem(
                      key: ValueKey('editableActionBarTextButton'),
                      icon: Icon(
                        Icons.format_size,
                        color: kIconColor,
                        size: kIconSize,
                      ),
                      text: 'TEXT',
                      onTap: widget.onText,
                    ),
                  ],
                ),
              ),
              Divider(indent: kFloatingRadius + 5),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    EditorActionItem(
                      key: ValueKey('editableActionBarSettingsButton'),
                      icon: Icon(
                        Icons.settings,
                        color: kIconColor,
                        size: kIconSize,
                      ),
                      text: 'SETTINGS',
                      onTap: widget.onSettings,
                    ),
                    EditorActionItem(
                      key: ValueKey('editableActionBarPreviewButton'),
                      icon: Icon(
                        Icons.play_arrow,
                        color: kIconColor,
                        size: kIconSize,
                      ),
                      text: 'PREVIEW',
                      onTap: widget.onPreview,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// **************************************************** /BOTTOM BAR ITEMS\ ****************************************************
