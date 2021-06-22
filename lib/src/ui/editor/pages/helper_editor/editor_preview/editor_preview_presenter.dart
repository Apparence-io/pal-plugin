import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/client/helper_factory.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview_viewmodel.dart';

import 'editor_preview.dart';
import 'editor_preview_viewmodel.dart';

class EditorPreviewPresenter extends Presenter<EditorPreviewModel, EditorPreviewView> {
  final EditorHelperService helperService;

  EditorPreviewPresenter(
    EditorPreviewView viewInterface, {
    required this.helperService,
    required EditorPreviewArguments args,
  }) : super(EditorPreviewModel(args.helperId, args.onDismiss, args.preBuiltHelper), viewInterface);

  @override
  void onInit() {
    // INIT
    this.viewModel.loading = true;
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
}
