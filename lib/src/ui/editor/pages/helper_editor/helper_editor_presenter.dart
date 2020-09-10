import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_loader.dart';

import 'helper_editor.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPresenter
    extends Presenter<HelperEditorViewModel, HelperEditorView> {
  final HelperService helperService;
  final HelperEditorLoader loader;
  final HelperEditorPageArguments basicArguments;

  HelperEditorPresenter(
    HelperEditorView viewInterface,
    this.basicArguments,
    this.loader,
    this.helperService,
  ) : super(HelperEditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
    viewModel.toolbarIsVisible = false;
    viewModel.isLoading = false;
    viewModel.isEditingWidget = false;
    viewModel.isEditableWidgetValid = false;
    viewModel.toolbarPosition = Offset.zero;

    // Create a template helper model
    // this template will be copied to edited widget
    viewModel.templateViewModel = FullscreenHelperViewModel(
      name: basicArguments?.helperName,
      priority: basicArguments?.priority ?? 0,
      triggerType:
          basicArguments?.triggerType ?? HelperTriggerType.ON_SCREEN_VISIT,
      versionMinId: basicArguments?.versionMinId ?? 1,
      versionMaxId: basicArguments?.versionMaxId ?? 2,
    );
  }

  checkIfEditableWidgetFormValid(bool isFormValid) {
    viewModel.isEditableWidgetValid = isFormValid;
    this.refreshView();
  }

  // Simply copy all template data from [viewModel.defaultViewModel] to the
  // actual edited widget view model
  initEditedWidgetData(HelperType type) {
    viewModel.helperViewModel = EditorFactory.init(
      viewModel.templateViewModel,
      type,
    );
  }

  hideToolbar() {
    viewModel.toolbarIsVisible = false;
    this.refreshView();
  }

  onClickClose() {
    //TODO
  }



  Future<HelperEntity> save(
    String pageId,
    HelperViewModel helperViewModel,
  ) async {
    viewModel.isLoading = true;
    this.refreshView();

    CreateHelperEntity createHelperEntity =
        EditorFactory.build(helperViewModel);
    HelperEntity helperEntity =
        await this.helperService.createPageHelper(pageId, createHelperEntity);
    viewModel.isLoading = false;
    this.refreshView();

    return helperEntity;
  }
}
