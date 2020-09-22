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
      BuildContext context, EditorUpdateHelperPresenter presenter);
  UpdateHelperViewModel getModel();
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
    return SafeArea(
      child: Padding(
        // Ignore bottom actions button
        padding: const EdgeInsets.only(bottom: 90.0),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Form(
            key: model.formKey,
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 40.0),
                                    child: Image.asset(
                                      'packages/palplugin/assets/images/create_helper.png',
                                      height: 200.0,
                                    ),
                                  ),
                                  _buildTitleField(context, presenter, model),
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
                          child: _buildThanksButton(context, presenter, model),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 20.0,
                      left: 20.0,
                      child: CircleIconButton(
                        icon: Icon(Icons.invert_colors),
                        backgroundColor: PalTheme.of(context).colors.light,
                        onTapCallback: () =>
                            presenter.changeBackgroundColor(context, presenter),
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

  _buildTitleField(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final EditorUpdateHelperModel model,
  ) {
    return EditableTextField.floating(
      helperToolbarKey: ValueKey(
        'pal_EditorUpdateHelperWidget_TitleToolbar',
      ),
      textFormFieldKey: ValueKey(
        'pal_EditorUpdateHelperWidget_TitleField',
      ),
      textEditingController: model.titleController,
      hintText: viewModel?.titleText?.value,
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
      height: 50.0,
      child: RaisedButton(
        color: PalTheme.of(context).colors.color1,
        child: TextField(
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
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
  UpdateHelperViewModel getModel() {
    return this.viewModel;
  }
}
