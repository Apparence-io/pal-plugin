import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/pages/editor/widgets/editor_banner.dart';
import 'package:palplugin/src/ui/pages/editor/widgets/editor_button.dart';
import 'package:palplugin/src/ui/widgets/modal_bottomsheet_options.dart';
import 'package:palplugin/src/ui/widgets/overlayed.dart';

import 'editor_presenter.dart';
import 'editor_viewmodel.dart';



abstract class EditorView {

}

class EditorPageBuilder implements EditorView {

  final mvvmPageBuilder = MVVMPageBuilder<EditorPresenter, EditorViewModel>();

  Widget build(BuildContext context) {
    return mvvmPageBuilder.build(
      key: ValueKey("EditorPage"),
      context: context,
      presenterBuilder: (context) => EditorPresenter(this),
      builder: (mContext, presenter, model) => _buildEditorPage(mContext.buildContext)
    );
  }

  _buildEditorPage(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(.2),
        child: Stack(
          children: [
            _buildAddButton(context),
            _buildValidationActions(context),
            _buildEditorMode(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorMode(BuildContext context) {
    return Positioned(
      top: 24, right: -24,
      child: Transform.rotate(
        angle: pi/4,
        child: EditorModeBanner()
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Positioned(
        bottom: 16,
        right: 16,
        child: EditorButton.editMode(
            PalTheme.of(context),
            () => _showHelperModal(context),
            key: ValueKey("editModeButton"),
        ),
      );
  }

  Widget _buildValidationActions(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EditorButton.cancel(
            PalTheme.of(context),
            () => Overlayed.removeOverlay(context, OverlayKeys.EDITOR_OVERLAY_KEY),
            key: ValueKey("editModeCancel"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: EditorButton.validate(
              PalTheme.of(context),
              () => _showHelperModal(context),
              key: ValueKey("editModeValidate"),
            ),
          ),
        ],
      )
    );
  }

  _showHelperModal(BuildContext context) {
    showModalBottomSheetOptions(
      context,
      (context) => ModalBottomSheetOptions(
        options: [
          SheetOption(text: "Simple helper box", icon: Icons.border_outer),
          SheetOption(text: "Fullscreen helper", icon: Icons.border_outer),
        ],
      )
    );
  }

}
