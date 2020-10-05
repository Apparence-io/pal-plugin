import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/color_picker.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_textfield.dart';
import 'package:palplugin/src/ui/shared/widgets/circle_button.dart';

abstract class EditorUpdateHelperView {
  void showColorPickerDialog(
    BuildContext context,
    EditorUpdateHelperPresenter presenter,
  );
  void scrollToBottomChangelogList(
    EditorUpdateHelperModel model,
  );
}

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
      key: ValueKey('pal_EditorUpdateHelperWidget_Builder'),
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
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: GestureDetector(
        onTap: presenter.onOutsideTap,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding:
                EdgeInsets.only(bottom: (model.isKeyboardVisible ? 0.0 : 90.0)),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Form(
                key: model.formKey,
                autovalidate: false,
                onChanged: () {
                  if (onFormChanged != null) {
                    onFormChanged(model.formKey?.currentState?.validate());
                  }
                },
                child: DottedBorder(
                  strokeWidth: 2.0,
                  strokeCap: StrokeCap.round,
                  dashPattern: [10, 7],
                  color: Colors.black54,
                  child: Container(
                    width: double.infinity,
                    color: viewModel.backgroundColor?.value,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                reverse: false,
                                controller: model.scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 40.0),
                                        child: Icon(
                                          Icons.image,
                                          size: 200.0,
                                          color: Color(0xFF898989),
                                        ),
                                      ),
                                      _buildTitleField(
                                          context, presenter, model),
                                      SizedBox(height: 25.0),
                                      _buildChangelogFields(
                                          context, presenter, model),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 15.0,
                                left: 10.0,
                                right: 10.0,
                              ),
                              child:
                                  _buildThanksButton(context, presenter, model),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 20.0,
                          left: 20.0,
                          child: CircleIconButton(
                            key: ValueKey(
                                'pal_EditorUpdateHelperWidget_BackgroundColorPicker'),
                            icon: Icon(Icons.invert_colors),
                            backgroundColor: PalTheme.of(context).colors.light,
                            onTapCallback: () => presenter
                                .changeBackgroundColor(context, presenter),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildTitleField(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final EditorUpdateHelperModel model,
  ) {
    return EditableTextField.text(
      helperToolbarKey: ValueKey(
        'pal_EditorUpdateHelperWidget_TitleToolbar',
      ),
      textFormFieldKey: ValueKey(
        'pal_EditorUpdateHelperWidget_TitleField',
      ),
      hintText: viewModel.titleField?.hintText,
      onChanged: presenter.onTitleFieldChanged,
      autovalidate: false,
      maximumCharacterLength: 60,
      minimumCharacterLength: 1,
      outsideTapStream: model.editableTextFieldController.stream,
      textStyle: TextStyle(
        color: viewModel.titleField?.fontColor?.value,
        fontSize: viewModel.titleField?.fontSize?.value,
      ),
    );
  }

  _buildChangelogFields(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final EditorUpdateHelperModel model,
  ) {
    return Column(
      children: [
        Wrap(
          children: model.changelogsTextfieldWidgets,
          spacing: 5.0,
          runSpacing: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 16.0),
          child: CircleIconButton(
            key: ValueKey('pal_EditorUpdateHelperWidget_AddNote'),
            backgroundColor: Colors.transparent,
            icon: Icon(
              Icons.add,
              color: Colors.grey.withAlpha(170),
              size: 35.0,
            ),
            displayShadow: false,
            onTapCallback: () {
              HapticFeedback.selectionClick();
              presenter.addChangelogNote();
              this.scrollToBottomChangelogList(model);
            },
          ),
        ),
      ],
    );
  }

  _buildThanksButton(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final EditorUpdateHelperModel model,
  ) {
    return SizedBox(
      width: double.infinity,
      child: EditableTextField.text(
        helperToolbarKey: ValueKey(
          'pal_EditorUpdateHelperWidget_ThanksButtonToolbar',
        ),
        textFormFieldKey: ValueKey(
          'pal_EditorUpdateHelperWidget_ThanksButtonField',
        ),
        outsideTapStream: model.editableTextFieldController.stream,
        onChanged: presenter.onThanksFieldChanged,
        hintText: viewModel.thanksButton?.hintText,
        maximumCharacterLength: 25,
        backgroundBoxDecoration: BoxDecoration(
          color: PalTheme.of(context).colors.color1,
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  void showColorPickerDialog(
      BuildContext context, EditorUpdateHelperPresenter presenter) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      child: ColorPickerDialog(
        placeholderColor: this.viewModel?.backgroundColor?.value,
        onColorSelected: presenter.updateBackgroundColor,
      ),
    );
  }

  scrollToBottomChangelogList(
    EditorUpdateHelperModel model,
  ) {
    if (model.scrollController.hasClients) {
      model.scrollController.animateTo(
        model.scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    }
  }
}
