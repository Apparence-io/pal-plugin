import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

import '../../../theme.dart';
import 'editor_menu.dart';

class EditorViewModel extends MVVMModel {

}

abstract class EditorView {

}


class EditorPageBuilder implements EditorView {

  final mvvmPageBuilder = MVVMPageBuilder<EditorPresenter, EditorViewModel>();

  Widget build(BuildContext context) {
    return mvvmPageBuilder.build(
      context: context,
      presenterBuilder: (context) => EditorPresenter(this),
      builder: (mContext, presenter, model) => _buildEditorPage(mContext.buildContext)
    );
  }

  _buildEditorPage(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomNavigationBar: EditorMenu()
    );
  }

}


class EditorPresenter extends Presenter<EditorViewModel, EditorView> {

  EditorPresenter(EditorView viewInterface) : super(EditorViewModel(), viewInterface);


}