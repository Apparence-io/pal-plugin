import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_models.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_service.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/extensions/color_extension.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

import 'helper_editor.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPresenter extends Presenter<HelperEditorViewModel, HelperEditorView> {

  final EditorHelperService helperService;

  final ElementFinder elementFinder;

  final HelperEditorPageArguments basicArguments;

  HelperEditorPresenter(HelperEditorView viewInterface, this.basicArguments,
    this.helperService, this.elementFinder)
    : super(HelperEditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
    viewModel.isLoading = false;
    viewModel.isEditingWidget = false;
    viewModel.isEditableWidgetValid = false;
    // Create a template helper model
    // this template will be copied to edited widget
    viewModel.templateViewModel = HelperViewModel(
      name: basicArguments?.helperName,
      priority: basicArguments?.priority ?? 0,
      triggerType: basicArguments?.triggerType ?? HelperTriggerType.ON_SCREEN_VISIT,
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
    viewModel.helperViewModel = EditorViewModelFactory.transform(viewModel.templateViewModel, helperType,);
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
      case HelperType.UPDATE_HELPER:
        viewInterface.addUpdateHelperEditor(viewModel.helperViewModel, checkIfEditableWidgetFormValid);
        break;
      default:
        throw "Not implemented type";
        break;
    }
    viewModel.isEditingWidget = true;
    refreshView();
  }

  onClickClose() {
    //TODO
  }

  Future<void> save() async {
    viewModel.isLoading = true;
    this.refreshView();
    try {
      var _config = CreateHelperConfig(
        name: basicArguments.helperName,
        triggerType: basicArguments.triggerType,
        priority: basicArguments.priority,
        versionMinId: basicArguments.versionMinId,
        versionMaxId: basicArguments.versionMaxId,
      );
      switch (basicArguments?.helperType) {
        case HelperType.HELPER_FULL_SCREEN:
          var model = viewModel.helperViewModel as FullscreenHelperViewModel;
          await helperService.createFullScreenHelper(
            basicArguments.pageId,
            EditorEntityFactory.buildFullscreenArgs(_config, model)
          );
          break;
        // case HelperType.SIMPLE_HELPER:
        //   break;
        // case HelperType.ANCHORED_OVERLAYED_HELPER:
        //   break;
        // case HelperType.UPDATE_HELPER:
        //   break;
        default:
          throw "NOT_IMPLEMENTED_TYPE";
          break;
      }
    } catch (e) {

    }
    viewModel.isLoading = false;
    // TODO show a success screen
    this.refreshView();
  }

  //----------------------------------------------------------------------
  // PRIVATES
  //----------------------------------------------------------------------

}
