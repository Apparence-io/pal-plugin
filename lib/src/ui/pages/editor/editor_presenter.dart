import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/helpers/fullscreen/fullscreen_helper_widget.dart';

import 'editor.dart';
import 'editor_viewmodel.dart';

class EditorPresenter extends Presenter<EditorViewModel, EditorView> {

  EditorPresenter(EditorView viewInterface) : super(EditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
    viewModel.toobarIsVisible = false;
    viewModel.toolbarPosition = Offset.zero;
  }

  closeToolbar() {
    viewModel.toobarIsVisible = true;
    this.refreshView();
  }
  
  showToolbar(Size helperSize, Offset helperPosition) {
    viewModel.toobarIsVisible = true;
    viewModel.toolbarPosition = Offset(helperPosition.dx, helperPosition.dy - 25.0);
    viewModel.toolbarSize = Size(helperSize.width, 25.0);
    this.refreshView();
  }

  hideToolbar() {
    viewModel.toobarIsVisible = false;
    this.refreshView();
  }
}