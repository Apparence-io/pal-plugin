import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/color_picker.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_textfield.dart';
import 'package:palplugin/src/ui/shared/widgets/circle_button.dart';

abstract class EditorFullScreenHelperView {
  void showColorPickerDialog(
    FullscreenHelperViewModel viewModel,
    EditorFullScreenHelperPresenter presenter,
  );
}

class EditorFullScreenHelper implements EditorFullScreenHelperView {
  BuildContext context;

  EditorFullScreenHelper(this.context);

  @override
  void showColorPickerDialog(
    FullscreenHelperViewModel viewModel,
    EditorFullScreenHelperPresenter presenter,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: this.context,
      child: ColorPickerDialog(
        placeholderColor: viewModel.backgroundColor?.value,
        onColorSelected: presenter.updateBackgroundColor,
      ),
    );
  }
}

class EditorFullScreenHelperPage extends StatelessWidget {
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
          EditorFullScreenHelperPresenter(new EditorFullScreenHelper(context), viewModel),
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
      onTap: presenter.onOutsideTap,
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
              child: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EditableTextField(
                              outsideTapStream:
                                  model.editableTextFieldController.stream,
                              helperToolbarKey: ValueKey(
                                  'palEditorFullscreenHelperWidgetToolbar'),
                              textFormFieldKey:
                                  ValueKey('palFullscreenHelperTitleField'),
                              onChanged: presenter.onTitleChanged,
                              maximumCharacterLength: 20,
                              minimumCharacterLength: 1,
                              textStyle: TextStyle(
                                color: viewModel.titleField?.fontColor?.value,
                                decoration: TextDecoration.none,
                                fontSize: viewModel.titleField?.fontSize?.value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: InkWell(
                                key: ValueKey("positiveFeedback"),
                                child: Text(
                                  "Ok, thanks !",
                                  style: TextStyle(
                                    color: Colors.white,
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
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20.0,
                      left: 20.0,
                      child: CircleIconButton(
                        key: ValueKey(
                            'pal_EditorFullScreenHelperPage_BackgroundColorPicker'),
                        icon: Icon(Icons.invert_colors),
                        backgroundColor: PalTheme.of(context).colors.light,
                        onTapCallback: () =>
                            presenter.changeBackgroundColor(viewModel, presenter),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
