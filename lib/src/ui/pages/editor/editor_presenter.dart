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
    CreateHelperFullScreenEntity fullScreenEntity =
        CreateHelperFullScreenEntity(
      title: viewModel.fullscreenHelperNotifier.titleNotifier.value,
      fontColor: viewModel.fullscreenHelperNotifier.fontColorNotifier.value,
      backgroundColor:
          viewModel.fullscreenHelperNotifier.backgroundColorNotifier.value,
      borderColor: viewModel.fullscreenHelperNotifier.borderColorNotifier.value,
      languageId: viewModel.fullscreenHelperNotifier.languageIdNotifier.value,
    );
    await this.loader.saveHelper(
          name: 'Un nom',
          priority: 0,
          triggerType: 'ON_SCREEN_VISIT',
          versionMaxId: 2,
          versionMinId: 1,
          pageId: pageId,
          helperEntity: fullScreenEntity,
        );

    viewModel.isLoading = false;
    this.refreshView();
  }
}
