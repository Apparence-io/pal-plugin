import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/editor_banner.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:palplugin/src/ui/editor/widgets/modal_bottomsheet_options.dart';
import 'package:palplugin/src/ui/shared/widgets/overlayed.dart';

import 'helper_editor_presenter.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPageArguments {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;

  final String helperName;
  final int priority;
  final HelperTriggerType triggerType;
  final int versionMinId;
  final int versionMaxId;

  HelperEditorPageArguments(
    this.hostedAppNavigatorKey,
    this.pageId, {
    this.helperName,
    this.priority,
    this.triggerType,
    this.versionMinId,
    this.versionMaxId,
  });
}

abstract class HelperEditorView {
  showHelperModal(
    final BuildContext context,
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
  );
  addNewHelper(
    final BuildContext context,
    final HelperType helperType,
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
  );
  removeOverlay(final BuildContext context);
}

class HelperEditorPageBuilder implements HelperEditorView {
  final HelperEditorPageArguments helperEditorPageArguments;
  final HelperService helperService;
  final HelperEditorLoader loader;

  final _mvvmPageBuilder =
      MVVMPageBuilder<HelperEditorPresenter, HelperEditorViewModel>();
  Widget _helperToEdit;

  HelperEditorPageBuilder(
    this.helperEditorPageArguments, {
    this.loader,
    this.helperService,
  });

  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey("EditorPage"),
      context: context,
      presenterBuilder: (context) => HelperEditorPresenter(
        this,
        helperEditorPageArguments,
        loader ?? HelperEditorLoader(),
        helperService ?? EditorInjector.of(context).helperService,
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
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
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
              if (model.isEditingWidget) _helperToEdit,
              (!model.isLoading)
                  ? Stack(
                      key: ValueKey('palEditorModeInteractUI'),
                      children: [
                        if (!model.isEditingWidget)
                          _buildAddButton(context, presenter, model),
                        _buildValidationActions(context, presenter, model),
                        _buildBannerEditorMode(context),
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
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
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
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
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
          if (model.isEditingWidget)
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: EditorButton.validate(
                PalTheme.of(context),
                model.isEditableWidgetValid
                    ? () async {
                        await presenter.save(helperEditorPageArguments.pageId,
                            model.helperViewModel);
                        await Future.delayed(Duration(milliseconds: 500));

                        removeOverlay(context);
                      }
                    : null,
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
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
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
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
  ) {
    switch (helperType) {
      case HelperType.HELPER_FULL_SCREEN:
        presenter.initEditedWidgetData(HelperType.HELPER_FULL_SCREEN);
        _helperToEdit = EditorFullScreenHelperPage(
          viewModel: model.helperViewModel,
          onFormChanged: presenter.checkIfEditableWidgetFormValid,
        );
        break;
      case HelperType.SIMPLE_HELPER:
        presenter.initEditedWidgetData(HelperType.SIMPLE_HELPER);
        _helperToEdit = EditorSimpleHelperPage(
          viewModel: model.helperViewModel,
          onFormChanged: presenter.checkIfEditableWidgetFormValid,
        );
        break;
      default:
    }
    model.isEditingWidget = (_helperToEdit != null);
    presenter.refreshView();
  }

  @override
  removeOverlay(BuildContext context) {
    // FIXME: Don't work when a set state was triggered
    Overlayed.removeOverlay(
      helperEditorPageArguments.hostedAppNavigatorKey.currentContext,
      OverlayKeys.EDITOR_OVERLAY_KEY,
    );
  }
}
