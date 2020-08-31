import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_loader.dart';

import 'helper_editor.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPresenter extends Presenter<HelperEditorViewModel, HelperEditorView> {
  final HelperService helperService;
  final HelperEditorLoader loader;

  HelperEditorPresenter(
    HelperEditorView viewInterface,
    this.loader,
    this.helperService,
  ) : super(HelperEditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
    viewModel.toolbarIsVisible = false;
    viewModel.isLoading = false;
    viewModel.toolbarPosition = Offset.zero;

    // FIXME: Mocked version, need to be modified on UI
    viewModel.fullscreenHelperViewModel = FullscreenHelperViewModel(
      name: 'Test from app',
      priority: 0,
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      versionMinId: 1,
      versionMaxId: 2,
    );
  }

  showToolbar(Size helperSize, Offset helperPosition) {
    viewModel.toolbarIsVisible = true;
    viewModel.toolbarPosition =
        Offset(helperPosition.dx, helperPosition.dy - 25.0);
    viewModel.toolbarSize = Size(helperSize.width, 25.0);
    this.refreshView();
  }

  hideToolbar() {
    viewModel.toolbarIsVisible = false;
    this.refreshView();
  }

  // saveFullscreenHelper(String pageId) async {
  //   viewModel.isLoading = true;
  //   this.refreshView();

  //   // Create fullscren infos only
  //   await this.helperService.createPageHelper(
  //         pageId,
  //         HelperEditorFactory.build(viewModel.basicHelperModel),
  //       );

  //   viewModel.isLoading = false;
  //   this.refreshView();
  // }

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
