import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/helpers/fullscreen/fullscreen_helper_widget.dart';
import 'package:palplugin/src/ui/pages/editor/editor_loader.dart';
import 'package:palplugin/src/ui/pages/editor/widgets/editor_banner.dart';
import 'package:palplugin/src/ui/pages/editor/widgets/editor_button.dart';
import 'package:palplugin/src/ui/widgets/edit_helper_toolbar.dart';
import 'package:palplugin/src/ui/widgets/modal_bottomsheet_options.dart';
import 'package:palplugin/src/ui/widgets/overlayed.dart';

import 'editor_presenter.dart';
import 'editor_viewmodel.dart';

abstract class EditorView {
  showHelperModal(
    final BuildContext context,
    final EditorPresenter presenter,
    final EditorViewModel model,
  );
  addNewHelper(
    final BuildContext context,
    final HelperType helperType,
    final EditorPresenter presenter,
    final EditorViewModel model,
  );
  unFocusCurrentTextField(final BuildContext context);
  removeOverlay(final BuildContext context);
}

class EditorPageBuilder implements EditorView {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;

  final _mvvmPageBuilder = MVVMPageBuilder<EditorPresenter, EditorViewModel>();
  final EditorLoader loader;
  Widget _helperToEdit;

  EditorPageBuilder(
    this.pageId,
    this.hostedAppNavigatorKey, {
    this.loader,
  });

  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey("EditorPage"),
      context: context,
      presenterBuilder: (context) => EditorPresenter(
        this,
        loader: this.loader ??
            EditorLoader(
              EditorInjector.of(context).helperService,
            ),
      ),
      builder: (mContext, presenter, model) => _buildEditorPage(
        mContext.buildContext,
        presenter,
        model,
      ),
    );
  }

  _buildEditorPage(
    final BuildContext context,
    final EditorPresenter presenter,
    final EditorViewModel model,
  ) {
    return WillPopScope(
      onWillPop: () {
        removeOverlay(context);
        return Future.value(false);
      },
      child: Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Container(
          color: Colors.black.withOpacity(.2),
          child: Stack(
            children: [
              // TODO: Put here helpers widget
              // just create a stack if there is more than one widgets
              if (_helperToEdit != null) _helperToEdit,
              (!model.isLoading)
                  ? Stack(
                      key: ValueKey('palEditorModeInteractUI'),
                      children: [
                        if (_helperToEdit == null)
                          _buildAddButton(context, presenter, model),
                        _buildValidationActions(context, presenter),
                        _buildBannerEditorMode(context),
                        if (model.toobarIsVisible &&
                            model.toolbarPosition != null)
                          Positioned(
                            top: model.toolbarPosition.dy - 8.0,
                            left: model.toolbarPosition.dx,
                            right: model.toolbarPosition.dx,
                            child: EditHelperToolbar(
                              onChangeBorderTap: () {
                                // TODO: To implement
                              },
                              onCloseTap: () {
                                presenter.hideToolbar();
                                unFocusCurrentTextField(context);
                              },
                              onChangeFontTap: () {
                                // TODO: To implement
                              },
                              onEditTextTap: () {
                                // TODO: To implement
                              },
                            ),
                          )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerEditorMode(BuildContext context) {
    return Positioned(
      top: 24,
      right: -24,
      child: Transform.rotate(angle: pi / 4, child: EditorModeBanner()),
    );
  }

  Widget _buildAddButton(
    final BuildContext context,
    final EditorPresenter presenter,
    final EditorViewModel model,
  ) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: EditorButton.editMode(
        PalTheme.of(context),
        () => showHelperModal(context, presenter, model),
        key: ValueKey("editModeButton"),
      ),
    );
  }

  Widget _buildValidationActions(
    final BuildContext context,
    final EditorPresenter presenter,
  ) {
    return Positioned(
      bottom: 32,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EditorButton.cancel(
            PalTheme.of(context),
            () => removeOverlay(context),
            key: ValueKey("editModeCancel"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: EditorButton.validate(
              PalTheme.of(context),
              () async {
                await presenter.saveFullscreenHelper(pageId);
                await Future.delayed(Duration(milliseconds: 500));

                removeOverlay(context);
              },
              key: ValueKey("editModeValidate"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  showHelperModal(
    final BuildContext context,
    final EditorPresenter presenter,
    final EditorViewModel model,
  ) {
    showModalBottomSheetOptions(
      context,
      (context) => ModalBottomSheetOptions(
        onValidate: (SheetOption anOption) {
          // First dismiss the bottom modal sheet
          Navigator.pop(context);

          // Then assign in stack the selected helper
          addNewHelper(context, anOption.type, presenter, model);
        },
        options: [
          SheetOption(
            text: "Simple helper box",
            icon: Icons.border_outer,
            type: HelperType.SIMPLE_HELPER,
          ),
          SheetOption(
            text: "Fullscreen helper",
            icon: Icons.border_outer,
            type: HelperType.HELPER_FULL_SCREEN,
          ),
        ],
      ),
    );
  }

  @override
  addNewHelper(
    final BuildContext context,
    final HelperType helperType,
    final EditorPresenter presenter,
    final EditorViewModel model,
  ) {
    switch (helperType) {
      case HelperType.HELPER_FULL_SCREEN:
        _helperToEdit = FullscreenHelperWidget.editor(
          fullscreenHelperNotifier: model.fullscreenHelperNotifier,
          onTitleFocusChanged: (bool hasFocus, Size size, Offset position) {
            if (!hasFocus) {
              presenter.hideToolbar();
            } else {
              presenter.showToolbar(size, position);
            }
          },
        );
        break;
      case HelperType.SIMPLE_HELPER:
        // TODO: Add simple helper widget
        break;
      default:
    }
    presenter.refreshView();
  }

  @override
  unFocusCurrentTextField(final BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  removeOverlay(BuildContext context) {
    Overlayed.removeOverlay(
      hostedAppNavigatorKey.currentContext,
      OverlayKeys.EDITOR_OVERLAY_KEY,
    );
  }
}
