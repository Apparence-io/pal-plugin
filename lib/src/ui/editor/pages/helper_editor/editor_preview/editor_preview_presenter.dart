import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview_viewmodel.dart';

import 'editor_preview.dart';
import 'editor_preview_viewmodel.dart';

class EditorPreviewPresenter extends Presenter<EditorPreviewModel, EditorPreviewView>{
  EditorPreviewPresenter(
    EditorPreviewView viewInterface,
  ) : super(EditorPreviewModel(), viewInterface);

  @override
  void onInit() { }

}