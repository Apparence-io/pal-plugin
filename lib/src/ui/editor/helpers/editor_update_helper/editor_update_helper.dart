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
  void addChangelogNoteTextField(
    EditorUpdateHelperModel model,
    Key textFormFieldKey,
    Key textFormToolbarKey,
    String hintText,
    String textFormMapKey,
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
          child: Padding(
            padding:
                EdgeInsets.only(bottom: (model.isKeyboardVisible ? 0.0 : 90.0)),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Form(
                key: model.formKey,
                autovalidate: true,
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
                                reverse: true,
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
                                        child: Image.asset(
                                          'packages/palplugin/assets/images/create_helper.png',
                                          height: 200.0,
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
    return EditableTextField(
      helperToolbarKey: ValueKey(
        'pal_EditorUpdateHelperWidget_TitleToolbar',
      ),
      textFormFieldKey: ValueKey(
        'pal_EditorUpdateHelperWidget_TitleField',
      ),
      hintText: 'Enter your title here...',
      onChanged: presenter.onTitleFieldChanged,
      maximumCharacterLength: 60,
      minimumCharacterLength: 1,
      outsideTapStream: model.editableTextFieldController.stream,
      textStyle: TextStyle(
        color: viewModel.titleFontColor?.value ??
            PalTheme.of(context).simpleHelperFontColor,
        fontSize: viewModel.titleFontSize?.value ?? 24.0,
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
              presenter.addChangelogNote(model);
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
      child: EditableTextField(
        helperToolbarKey: ValueKey(
          'pal_EditorUpdateHelperWidget_ThanksButtonToolbar',
        ),
        textFormFieldKey: ValueKey(
          'pal_EditorUpdateHelperWidget_ThanksButtonField',
        ),
        outsideTapStream: model.editableTextFieldController.stream,
        onChanged: presenter.onThanksFieldChanged,
        hintText: 'Thank you!',
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
        onColorSelected: (Color aColor) {
          this.viewModel.backgroundColor.value = aColor;
          presenter.refreshView();
        },
      ),
    );
  }

  @override
  void addChangelogNoteTextField(
    EditorUpdateHelperModel model,
    Key textFormFieldKey,
    Key textFormToolbarKey,
    String hintText,
    String textFormMapKey,
  ) {
    // Assign defaults values
    this
        .viewModel
        .changelogFontColor
        ?.value
        ?.putIfAbsent(textFormMapKey, () => Colors.black87);
    this
        .viewModel
        .changelogFontSize
        ?.value
        ?.putIfAbsent(textFormMapKey, () => 14.0);
    this.viewModel.changelogText?.value?.putIfAbsent(
          textFormMapKey,
          () => '',
        );

    model.changelogsTextfieldWidgets.add(
      EditableTextField(
        textFormFieldKey: textFormFieldKey,
        helperToolbarKey: textFormToolbarKey,
        outsideTapStream: model.editableTextFieldController.stream,
        hintText: hintText,
        maximumCharacterLength: 120,
        textStyle: TextStyle(
          color: this.viewModel.changelogFontColor?.value[textFormMapKey],
          fontSize: this.viewModel.changelogFontSize?.value[textFormMapKey],
        ),
        onChanged: (Key key, String newValue) {
          this.viewModel.changelogText?.value[textFormMapKey] = newValue;
        },
      ),
    );
  }

  scrollToBottomChangelogList(
    EditorUpdateHelperModel model,
  ) {
    if (model.scrollController.hasClients) {
      model.scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    }
  }
}
