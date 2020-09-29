import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_loader.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

import 'helper_editor.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPresenter extends Presenter<HelperEditorViewModel, HelperEditorView> {

  final HelperService helperService;

  final ElementFinder elementFinder;

  final HelperEditorLoader loader;

  final HelperEditorPageArguments basicArguments;

  HelperEditorPresenter(
    HelperEditorView viewInterface,
    this.basicArguments,
    this.loader,
    this.helperService,
    this.elementFinder
  ) : super(HelperEditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
    viewModel.toolbarIsVisible = false;
    viewModel.isLoading = false;
    viewModel.isEditingWidget = false;
    viewModel.isEditableWidgetValid = false;
    viewModel.toolbarPosition = Offset.zero;

    // init the available helpers type we can create
    viewModel.availableHelperType = [
      HelperTypeOption("Simple helper box", HelperType.SIMPLE_HELPER),
      HelperTypeOption("Fullscreen helper", HelperType.HELPER_FULL_SCREEN),
      HelperTypeOption("Anchored fullscreen helper", HelperType.ANCHORED_OVERLAYED_HELPER),
    ];

    // Create a template helper model
    // this template will be copied to edited widget
    viewModel.templateViewModel = HelperViewModel(
      name: basicArguments?.helperName,
      priority: basicArguments?.priority ?? 0,
      triggerType:
          basicArguments?.triggerType ?? HelperTriggerType.ON_SCREEN_VISIT,
      versionMinId: basicArguments?.versionMinId ?? 1,
      versionMaxId: basicArguments?.versionMaxId ?? 2,
    );

    this.chooseHelperType(basicArguments?.helperType);
  }

  checkIfEditableWidgetFormValid(bool isFormValid) {
    viewModel.isEditableWidgetValid = isFormValid;
    this.refreshView();
  }

  chooseHelperType(HelperType helperType) {
    initEditedWidgetData(helperType);
    switch (helperType) {
      case HelperType.HELPER_FULL_SCREEN:
        viewInterface.addFullscreenHelperEditor(viewModel.helperViewModel, checkIfEditableWidgetFormValid);
        break;
      case HelperType.SIMPLE_HELPER:
        viewInterface.addSimpleHelperEditor(viewModel.helperViewModel, checkIfEditableWidgetFormValid);
        break;
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        viewInterface.addAnchoredFullscreenEditor(this);
        break;
      default:
        throw "Not implemented type";
        break;
    }
    viewModel.isEditingWidget = true;
    refreshView();
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

  //----------------------------------------------------------------------
  // PRIVATES
  //----------------------------------------------------------------------

  // Simply copy all template data from [viewModel.defaultViewModel] to the
  // actual edited widget view model
  initEditedWidgetData(HelperType type) {
    viewModel.helperViewModel = EditorFactory.init(
      viewModel.templateViewModel,
      type,
    );
  }
}
