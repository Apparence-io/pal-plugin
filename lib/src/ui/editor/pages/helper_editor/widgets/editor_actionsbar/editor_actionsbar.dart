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

class EditorActionsBar extends StatelessWidget {
  final Widget child;
  final OnCancel onCancel;
  final OnText onText;
  final OnSettings onSettings;
  final OnPreview onPreview;
  final OnValidate onValidate;
  final GlobalKey scaffoldKey;
  final bool visible;

  final kFloatingRadius = 45.0;

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
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      body: child,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton:
          visible ? this._buildSaveFloatingButton(context) : null,
      bottomNavigationBar: visible ? this._buildTabItems(context) : null,
    );
  }

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
      onTapCallback: this.onValidate != null
          ? () {
              HapticFeedback.mediumImpact();
              this.onValidate?.call();
            }
          : null,
    );
  }

  Widget _buildTabItems(BuildContext context) {
    final kIconColor = Colors.white;
    final kIconSize = 32.0;

    return BottomAppBar(
      color: PalTheme.of(context).colors.dark,
      shape: null,
      child: Container(
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
                        Icons.close,
                        color: kIconColor,
                        size: kIconSize,
                      ),
                      text: 'CANCEL',
                      onTap: this.onCancel,
                    ),
                    EditorActionItem(
                      key: ValueKey('editableActionBarTextButton'),
                      icon: Icon(
                        Icons.format_size,
                        color: kIconColor,
                        size: kIconSize,
                      ),
                      text: 'TEXT',
                      onTap: this.onText,
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
                      onTap: this.onSettings,
                    ),
                    EditorActionItem(
                      key: ValueKey('editableActionBarPreviewButton'),
                      icon: Icon(
                        Icons.play_arrow,
                        color: kIconColor,
                        size: kIconSize,
                      ),
                      text: 'PREVIEW',
                      onTap: this.onPreview,
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
