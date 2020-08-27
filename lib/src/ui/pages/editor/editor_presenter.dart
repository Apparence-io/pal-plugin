import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/ui/helpers/fullscreen/fullscreen_helper_widget.dart';
import 'package:palplugin/src/ui/pages/editor/editor_loader.dart';

import 'editor.dart';
import 'editor_viewmodel.dart';

class EditorPresenter extends Presenter<EditorViewModel, EditorView> {
  final EditorLoader loader;

  EditorPresenter(
    EditorView viewInterface, {
    @required this.loader,
  }) : super(EditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
    viewModel.toobarIsVisible = false;
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
    // Create fullscren infos only
    CreateHelperFullScreenEntity fullScreenEntity = CreateHelperFullScreenEntity(
      title: viewModel.fullscreenHelperNotifier.title.value,
      fontColor: viewModel.fullscreenHelperNotifier.fontColor.value,
      backgroundColor: viewModel.fullscreenHelperNotifier.backgroundColor.value,
      borderColor: viewModel.fullscreenHelperNotifier.borderColor.value,
      languageId: viewModel.fullscreenHelperNotifier.languageId.value,
    );
    await this.loader.saveHelper(pageId, fullScreenEntity);
  }
}
