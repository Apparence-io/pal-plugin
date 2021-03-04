import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview_viewmodel.dart';

import 'editor_preview.dart';
import 'editor_preview_viewmodel.dart';

class EditorPreviewPresenter
    extends Presenter<EditorPreviewModel, EditorPreviewView> {
  final EditorHelperService helperService;

  EditorPreviewPresenter(
    EditorPreviewView viewInterface, {
    @required this.helperService,
    @required EditorPreviewArguments args,
  }) : super(
            EditorPreviewModel(
                args.helperId, args.onDismiss, args.preBuiltHelper),
            viewInterface);

  @override
  void onInit() {
    // INIT
    this.viewModel.loading = true;
    // INIT

    if (this.viewModel.preBuiltHelper == null) {
      this.helperService.getHelper(this.viewModel.helperId).then((helper) {
        this.viewModel.helperEntity = helper;
        this.viewModel.loading = false;
        this.refreshView();
      });
    } else {
      this.viewModel.loading = false;
    }
  }

  Widget getHelper() {
    if (this.viewModel.preBuiltHelper != null)
      return this.viewModel.preBuiltHelper;
    // PARSING AND CREATING HELPER ENTITY
    switch (this.viewModel.helperEntity.type) {
      case HelperType.HELPER_FULL_SCREEN:
        return this.viewInterface.buildFullscreen(
            this.viewModel.helperEntity, this.viewModel.onDismiss);
      case HelperType.SIMPLE_HELPER:
        return this
            .viewInterface
            .buildSimple(this.viewModel.helperEntity, this.viewModel.onDismiss);
        break;
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        return this.viewInterface.buildAnchored(
            this.viewModel.helperEntity, this.viewModel.onDismiss);
        break;
      case HelperType.UPDATE_HELPER:
        return this
            .viewInterface
            .buildUpdate(this.viewModel.helperEntity, this.viewModel.onDismiss);
        break;
      default:
        return null;
    }
  }
}
