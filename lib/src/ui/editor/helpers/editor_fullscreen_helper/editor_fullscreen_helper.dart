import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_textfield.dart';

abstract class EditorFullScreenHelperView {}

class EditorFullScreenHelperPage extends StatelessWidget
    implements EditorFullScreenHelperView {
  final FullscreenHelperViewModel viewModel;
  final Function(bool) onFormChanged;

  EditorFullScreenHelperPage({
    Key key,
    @required this.viewModel,
    this.onFormChanged,
  });

  final _mvvmPageBuilder = MVVMPageBuilder<EditorFullScreenHelperPresenter,
      EditorFullScreenHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('palEditorFullscreenHelperWidgetBuilder'),
      context: context,
      presenterBuilder: (context) =>
          EditorFullScreenHelperPresenter(this, viewModel),
      builder: (context, presenter, model) {
        return this._buildPage(context.buildContext, presenter, model);
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorFullScreenHelperPresenter presenter,
    final EditorFullScreenHelperModel model,
  ) {
    return GestureDetector(
      key: ValueKey('palEditorFullscreenHelperWidget'),
      onTap: () {
        // Close the toolbar & unfocus textfield
        EditableTextField.globalKey.currentState.onCloseTap();
      },
      child: Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          opacity: model.helperOpacity,
          child: Form(
            key: model.formKey,
            autovalidate: true,
            onChanged: () {
              if (onFormChanged != null) {
                onFormChanged(model.formKey?.currentState?.validate());
              }
            },
            child: Container(
              color: viewModel.backgroundColor?.value,
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EditableTextField(
                            helperToolbarKey: ValueKey(
                                'palEditorFullscreenHelperWidgetToolbar'),
                            textFormFieldKey:
                                ValueKey('palFullscreenHelperTitleField'),
                            textEditingController: model.titleController,
                            textStyle: TextStyle(
                              color: viewModel.fontColor?.value,
                              decoration: TextDecoration.none,
                              fontSize: viewModel.fontSize?.value ??
                                  Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .fontSize,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: InkWell(
                              key: ValueKey("positiveFeedback"),
                              child: Text(
                                "Ok, thanks !",
                                style: TextStyle(
                                  color: viewModel.fontColor?.value,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: InkWell(
                              key: ValueKey("negativeFeedback"),
                              child: Text(
                                "This is not helping",
                                style: TextStyle(
                                  color: viewModel.fontColor?.value,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
