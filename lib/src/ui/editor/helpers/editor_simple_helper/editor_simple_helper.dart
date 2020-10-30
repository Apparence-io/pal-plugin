import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_presenter.dart';
import 'package:pal/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:pal/src/ui/editor/widgets/editable_textfield.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

abstract class EditorSimpleHelperView {
  void showColorPickerDialog(
    SimpleHelperViewModel viewModel,
    EditorSimpleHelperPresenter presenter,
  );
  TextStyle googleCustomFont(String fontFamily);
}

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        key: ValueKey('palEditorSimpleHelperWidget'),
        onTap: presenter.onOutsideTap,
        child: LayoutBuilder(builder: (context, constraints) {
          return Form(
            key: model.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              if (onFormChanged != null) {
                onFormChanged(model.formKey?.currentState?.validate());
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Column(
                      children: [
                        Expanded(child: Container()),
                        Container(
                          width: constraints.maxWidth * 0.8,
                          child: EditableTextField.text(
                            outsideTapStream:
                                model.editableTextFieldController.stream,
                            helperToolbarKey:
                                ValueKey('palEditorSimpleHelperWidgetToolbar'),
                            textFormFieldKey:
                                ValueKey('palSimpleHelperDetailField'),
                            onChanged: presenter.onDetailsFieldChanged,
                            onTextStyleChanged:
                                presenter.onDetailsTextStyleChanged,
                            maxLines: 3,
                            maximumCharacterLength: 150,
                            minimumCharacterLength: 1,
                            initialValue: viewModel?.detailsField?.text?.value,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                new RegExp(
                                  '^(.*(\n.*){0,2})',
                                ),
                              ),
                            ],
                            backgroundBoxDecoration: BoxDecoration(
                              color: viewModel?.backgroundColor?.value ??
                                  PalTheme.of(context).colors.light,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            backgroundPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom > 0
                                        ? MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            20.0
                                        : 110.0),
                            textFormFieldPadding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 33.0,
                            ),
                            textStyle: TextStyle(
                              color: viewModel.detailsField?.fontColor?.value,
                              fontSize: viewModel.detailsField?.fontSize?.value
                                  ?.toDouble(),
                              fontWeight: FontWeightMapper.toFontWeight(
                                viewModel.detailsField?.fontWeight?.value,
                              ),
                            ).merge(
                              googleCustomFont(
                                viewModel.detailsField?.fontFamily?.value,
                              ),
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
                  child: SafeArea(
                    child: CircleIconButton(
                      key: ValueKey(
                          'pal_EditorSimpleHelperWidget_CircleBackground'),
                      icon: Icon(Icons.invert_colors),
                      backgroundColor: PalTheme.of(context).colors.light,
                      onTapCallback: () =>
                          this.showColorPickerDialog(viewModel, presenter),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  void showColorPickerDialog(
    final SimpleHelperViewModel viewModel,
    final EditorSimpleHelperPresenter presenter,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: _scaffoldKey.currentContext,
      child: ColorPickerDialog(
        placeholderColor: viewModel.backgroundColor?.value,
        onColorSelected: presenter.updateBackgroundColor,
      ),
    );
  }

  @override
  TextStyle googleCustomFont(String fontFamily) {
    return (fontFamily != null && fontFamily.length > 0)
        ? GoogleFonts.getFont(fontFamily)
        : null;
  }
}
