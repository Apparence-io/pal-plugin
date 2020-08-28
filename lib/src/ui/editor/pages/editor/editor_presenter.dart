import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/services/editor_service.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper_widget.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper_widget.dart';

import 'editor.dart';
import 'editor_viewmodel.dart';

class EditorPresenter extends Presenter<EditorViewModel, EditorView> {
  final EditorService editorService;
  final HelperService helperService;

  EditorPresenter(
    EditorView viewInterface,
    this.editorService,
    this.helperService,
  ) : super(EditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
    viewModel.toobarIsVisible = false;
    viewModel.isLoading = false;
    viewModel.toolbarPosition = Offset.zero;

    viewModel.fullscreenHelperNotifier = FullscreenHelperNotifier();
  }

  showToolbar(Size helperSize, Offset helperPosition) {
    viewModel.toobarIsVisible = true;
    viewModel.toolbarPosition =
        Offset(helperPosition.dx, helperPosition.dy - 25.0);
    viewModel.toolbarSize = Size(helperSize.width, 25.0);
    this.refreshView();
  }

  hideToolbar() {
    viewModel.toobarIsVisible = false;
    this.refreshView();
  }

  saveFullscreenHelper(String pageId) async {
    viewModel.isLoading = true;
    this.refreshView();

    // Create fullscren infos only
    CreateHelperFullScreenEntity createHelperFullScreenEntity = this.editorService.saveFullscreenHelper(
          pageId,
          fullscreenHelperNotifier: viewModel.fullscreenHelperNotifier,
          name: 'Test',
          priority: 0,
          triggerType: HelperTriggerType.ON_SCREEN_VISIT,
          versionMinId: 1,
          versionMaxId: 2,
        );
    await this.helperService.createPageHelper(pageId, createHelperFullScreenEntity);

    viewModel.isLoading = false;
    this.refreshView();
  }
}
