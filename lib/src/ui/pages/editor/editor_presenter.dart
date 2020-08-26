import 'package:mvvm_builder/mvvm_builder.dart';

import 'editor.dart';
import 'editor_viewmodel.dart';

class EditorPresenter extends Presenter<EditorViewModel, EditorView> {

  EditorPresenter(EditorView viewInterface) : super(EditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
  }

}