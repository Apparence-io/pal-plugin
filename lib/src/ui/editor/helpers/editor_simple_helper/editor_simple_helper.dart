import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_textfield.dart';

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
      onTap: () {
        // Close the toolbar & unfocus textfield
        EditableTextField.globalKey.currentState.onCloseTap();
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                Expanded(child: Container()),
                Container(
                  width: constraints.maxWidth * 0.8,
                  child: EditableTextField.floating(
                    helperToolbarKey:
                        ValueKey('palEditorSimpleHelperWidgetToolbar'),
                    textFormFieldKey: ValueKey('palSimpleHelperDetailField'),
                    textEditingController: model.detailsController,
                    maxLines: null,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          new RegExp('^(.*(\n.*){0,2})')),
                    ],
                    backgroundBoxDecoration: BoxDecoration(
                      color: viewModel.backgroundColor?.value ??
                          PalTheme.of(context).simpleHelperBackgroundColor,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    backgroundPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom > 0
                            ? MediaQuery.of(context).viewInsets.bottom + 20.0
                            : 110.0),
                    textFormFieldPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 33.0,
                    ),
                    textStyle: TextStyle(
                      color: viewModel.fontColor?.value ??
                          PalTheme.of(context).simpleHelperFontColor,
                      fontSize: viewModel.fontSize?.value ?? 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}