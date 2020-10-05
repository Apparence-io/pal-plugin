import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_theme.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_anchored_helper/editor_anchored_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/editor_banner.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:palplugin/src/ui/editor/widgets/edit_helper_toolbar.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';
import 'package:palplugin/src/ui/shared/widgets/overlayed.dart';

import 'helper_editor_presenter.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPageArguments {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;

  final String helperName;
  final int priority;
  final HelperTriggerType triggerType;
  final HelperTheme helperTheme;
  final HelperType helperType;
  final int versionMinId;
  final int versionMaxId;

  HelperEditorPageArguments(
    this.hostedAppNavigatorKey,
    this.pageId, {
    @required this.helperName,
    this.priority,
    @required this.triggerType,
    @required this.helperTheme,
    @required this.helperType,
    this.versionMinId,
    this.versionMaxId,
  });
}

abstract class HelperEditorView {

  addFullscreenHelperEditor(FullscreenHelperViewModel model, Function isValid);

  addSimpleHelperEditor(SimpleHelperViewModel model, Function isValid);

  addUpdateHelperEditor(UpdateHelperViewModel model, Function isValid);

  addAnchoredFullscreenEditor(HelperEditorPresenter presenter);

  unFocusCurrentTextField(final BuildContext context);

  removeOverlay();
}

class HelperEditorPageBuilder implements HelperEditorView {

  final ElementFinder elementFinder;

  final HelperEditorPageArguments helperEditorPageArguments;

  final HelperService helperService;

  final HelperEditorLoader loader;

  final _mvvmPageBuilder = MVVMPageBuilder<HelperEditorPresenter, HelperEditorViewModel>();

  Widget _helperToEdit;

  HelperEditorPageBuilder(
    this.helperEditorPageArguments, {
    this.loader,
    this.helperService,
    this.elementFinder,
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
        elementFinder
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
        removeOverlay();
        return Future.value(false);
      },
      child: Material(
        key: ValueKey("EditorMaterial"),
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Container(
          color: Colors.black.withOpacity(.2),
          child: Stack(
            children: [
              if (model.isEditingWidget)
                Positioned.fill(child: _helperToEdit),
              (!model.isLoading)
                  ? Stack(
                      key: ValueKey('palEditorModeInteractUI'),
                      children: [
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

  Widget _buildValidationActions(
    final BuildContext context,
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
  ) {
    return Positioned(
      bottom: 25,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EditorButton.cancel(
            PalTheme.of(context),
            () => removeOverlay(),
            key: ValueKey("editModeCancel"),
          ),
          if (model.isEditingWidget)
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: EditorButton.validate(
                PalTheme.of(context),
                () async {
                  await presenter.save(
                      helperEditorPageArguments.pageId, model.helperViewModel);
                  await Future.delayed(Duration(milliseconds: 500));
                  removeOverlay();
                },
                key: ValueKey("editModeValidate"),
              ),
          ),
        ],
      ),
    );
  }

  // /////////////////////////////////////////:
  // HelperEditorView
  // /////////////////////////////////////////:

  addFullscreenHelperEditor(FullscreenHelperViewModel model, Function isValid) {
    _helperToEdit = EditorFullScreenHelperPage(
      viewModel: model,
      onFormChanged: isValid,
    );
  }

  addSimpleHelperEditor(SimpleHelperViewModel model, Function isValid) {
    _helperToEdit = EditorSimpleHelperPage(
      viewModel: model,
      onFormChanged: isValid,
    );
  }

  addUpdateHelperEditor(UpdateHelperViewModel model, Function isValid) {
    _helperToEdit = EditorUpdateHelperPage(
      viewModel: model,
      onFormChanged: isValid,
    );
  }

  addAnchoredFullscreenEditor(HelperEditorPresenter presenter) {
    _helperToEdit = EditorAnchoredFullscreenHelper( );
  }

  @override
  unFocusCurrentTextField(final BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  removeOverlay() {
    Overlayed.removeOverlay(
      helperEditorPageArguments.hostedAppNavigatorKey.currentContext,
      OverlayKeys.EDITOR_OVERLAY_KEY,
    );
  }
}
