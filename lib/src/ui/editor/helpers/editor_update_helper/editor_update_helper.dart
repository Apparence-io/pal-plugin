import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

abstract class EditorUpdateHelperView {}

class EditorUpdateHelperPage extends StatelessWidget
    implements EditorUpdateHelperView {
  final UpdateHelperViewModel viewModel;
  final Function(bool) onFormChanged;

  EditorUpdateHelperPage({
    Key key,
    @required this.viewModel,
    this.onFormChanged,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<EditorUpdateHelperPresenter, EditorUpdateHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('palEditorUpdateHelperWidgetBuilder'),
      context: context,
      presenterBuilder: (context) => EditorUpdateHelperPresenter(
        this,
        viewModel,
      ),
      builder: (context, presenter, model) {
        return this._buildPage(context.buildContext, presenter, model);
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final EditorUpdateHelperModel model,
  ) {
    return Text('TEST');
  }
}
