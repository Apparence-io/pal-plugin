import 'package:flutter/material.dart';
import 'package:pal/src/theme.dart';

import 'widgets/editor_action_item.dart';

typedef OnCancel();
typedef OnPreview();
typedef OnSettings();
typedef OnText();

class EditorActionBar extends StatelessWidget {
  // ANIMATION VALUE BETWEEN [0,1] 0 => Hidden; 1 => Shown
  final AnimationController animation;
  // ICONS ATTRIBUTES
  final Color? iconsColor;
  final double? iconsSize;
  // ONTAP FUNCTION
  final OnCancel? onCancel;
  final OnPreview? onPreview;
  final OnSettings? onSettings;
  final OnText? onText;
  // CONST ANIMATIONS BOUNDS
  final double kUpperbound = 65;
  final double kLowerbound = 0;

  EditorActionBar({
    this.iconsColor,
    this.iconsSize,
    this.onCancel,
    this.onPreview,
    this.onSettings,
    this.onText,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: this.animation,
      builder: (context, child) => Transform.translate(
          offset: Offset(0, this.animation.value * (MediaQuery.of(context).padding.bottom + kUpperbound)), child: child),
      child: BottomAppBar(
        color: PalTheme.of(context)!.colors.dark,
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
                        color: this.iconsColor,
                        size: this.iconsSize,
                      ),
                      text: 'QUIT',
                      onTap: this.onCancel,
                    ),
                    EditorActionItem(
                      key: ValueKey('editableActionBarTextButton'),
                      icon: Icon(
                        Icons.format_size,
                        color: this.iconsColor,
                        size: this.iconsSize,
                      ),
                      text: 'TEXT',
                      onTap: this.onText,
                    ),
                  ],
                ),
              ),
              Divider(indent: 45.0 + 5),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    EditorActionItem(
                      key: ValueKey('editableActionBarSettingsButton'),
                      icon: Icon(
                        Icons.settings,
                        color: this.iconsColor,
                        size: this.iconsSize,
                      ),
                      text: 'SETTINGS',
                      onTap: this.onSettings,
                    ),
                    EditorActionItem(
                      key: ValueKey('editableActionBarPreviewButton'),
                      icon: Icon(
                        Icons.play_arrow,
                        color: this.iconsColor,
                        size: this.iconsSize,
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
