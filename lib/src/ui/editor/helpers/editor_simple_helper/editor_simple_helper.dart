import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/edit_helper_toolbar.dart';

abstract class EditorSimpleHelperView {}

class EditorSimpleHelperPage extends StatelessWidget
    implements EditorSimpleHelperView {
  final SimpleHelperViewModel viewModel;
  final Function(bool) onFormChanged;

  EditorSimpleHelperPage({
    Key key,
    @required this.viewModel,
    this.onFormChanged,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<EditorSimpleHelperPresenter, EditorSimpleHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('palEditorSimpleHelperWidgetBuilder'),
      context: context,
      presenterBuilder: (context) => EditorSimpleHelperPresenter(
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
    final EditorSimpleHelperPresenter presenter,
    final EditorSimpleHelperModel model,
  ) {
    return GestureDetector(
      key: ValueKey('palEditorSimpleHelperWidget'),
      onTap: () => FocusScope.of(context).unfocus(),
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                Expanded(child: Container()),
                _buildDetailsFieldWithToolbar(
                  constraints,
                  context,
                  presenter,
                  model,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDetailsFieldWithToolbar(
    final BoxConstraints constraints,
    final BuildContext context,
    final EditorSimpleHelperPresenter presenter,
    final EditorSimpleHelperModel model,
  ) {
    return Container(
      width: constraints.maxWidth * 0.8,
      child: Column(
        key: ValueKey('palEditorSimpleHelperWidgetToolbar'),
        children: [
          if (model.isToolbarVisible)
            EditHelperToolbar(
              onChangeBorderTap: presenter.onChangeBorderTap,
              onCloseTap: presenter.onCloseTap,
              onChangeFontTap: presenter.onChangeFontTap,
              onEditTextTap: presenter.onEditTextTap,
            ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).viewInsets.bottom + 20.0
                    : 110.0),
            child: Container(
              key: model.containerKey,
              decoration: BoxDecoration(
                color: viewModel.backgroundColor?.value ??
                    PalTheme.of(context).simpleHelperBackgroundColor,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 33.0,
                ),
                child: Form(
                  key: model.formKey,
                  autovalidate: true,
                  onChanged: () {
                    if (onFormChanged != null) {
                      onFormChanged(model.formKey?.currentState?.validate());
                    }
                  },
                  child: _buildDetailsField(context, presenter, model),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsField(
    final BuildContext context,
    final EditorSimpleHelperPresenter presenter,
    final EditorSimpleHelperModel model,
  ) {
    return TextFormField(
      key: ValueKey('palSimpleHelperDetailField'),
      focusNode: model.detailsFocus,
      controller: model.detailsController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      autovalidate: true,
      onTap: presenter.onDetailTextFieldTapped,
      validator: presenter.validateDetailsTextField,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Edit me!',
        hintStyle: TextStyle(
          color: PalTheme.of(context).simpleHelperFontColor.withAlpha(80),
          decoration: TextDecoration.none,
          fontSize: viewModel.fontSize?.value ?? 14.0,
        ),
      ),
      style: TextStyle(
        color: viewModel.fontColor?.value ??
            PalTheme.of(context).simpleHelperFontColor,
        fontSize: viewModel.fontSize?.value ?? 14.0,
      ),
    );
  }
}
