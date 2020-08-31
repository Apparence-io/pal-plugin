import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/ui/editor/pages/editor/editor_factory.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper_widget.dart';

import 'editor.dart';
import 'editor_viewmodel.dart';

class EditorPresenter extends Presenter<EditorViewModel, EditorView> {
  final HelperService helperService;

  EditorPresenter(
    EditorView viewInterface,
    this.helperService,
  ) : super(EditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
    viewModel.toolbarIsVisible = false;
    viewModel.isLoading = false;
    viewModel.toolbarPosition = Offset.zero;

    // FIXME: Mocked version, need to be modified on UI
    viewModel.basicHelperModel = HelperViewModel(
      name: 'Test from app',
      priority: 0,
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      versionMinId: 1,
      versionMaxId: 2,
      helper: FullscreenHelperViewModel(),
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
