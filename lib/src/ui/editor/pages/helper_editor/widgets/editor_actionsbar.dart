import 'package:flutter/material.dart';

import '../../../../../theme.dart';
import 'editor_button.dart';

typedef OnCancel();

typedef OnValidate = Future<void> Function();

class EditorActionsBar extends StatelessWidget {

  final Widget child;
  final OnCancel onCancel;
  final OnValidate onValidate;
  final ValueNotifier<bool> canValidate;

  EditorActionsBar({this.child, this.onCancel, this.onValidate, this.canValidate, Key key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0, left: 0, right: 0,
          bottom: 72,
          child: child,
        ),
        _buildValidationActions(context)
      ],
    );
  }

  Widget _buildValidationActions(final BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 72,
      child: Container(
        color: PalTheme.of(context).toolbarBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EditorButton.cancel(
              PalTheme.of(context),
              onCancel,
              key: ValueKey("editModeCancel"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: ValueListenableBuilder<bool>(
                valueListenable: canValidate,
                builder: (context, isActive, child)
                  => EditorButton.validate(
                    PalTheme.of(context),
                    onValidate,
                    key: ValueKey("editModeValidate"),
                    isEnabled: isActive,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }


}
