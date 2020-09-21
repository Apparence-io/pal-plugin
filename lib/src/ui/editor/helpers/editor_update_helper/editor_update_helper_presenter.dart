import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_textfield.dart';
import 'package:palplugin/src/ui/shared/widgets/bordered_text_field.dart';

class EditorUpdateHelperPresenter
    extends Presenter<EditorUpdateHelperModel, EditorUpdateHelperView> {
  final UpdateHelperViewModel updateHelperViewModel;

  EditorUpdateHelperPresenter(
    EditorUpdateHelperView viewInterface,
    this.updateHelperViewModel,
  ) : super(EditorUpdateHelperModel(), viewInterface);

  @override
  void onInit() {
    super.onInit();

    // Init keys
    this.viewModel.containerKey = GlobalKey();
    this.viewModel.formKey = GlobalKey<FormState>();

    // Init details textfield
    this.viewModel.titleController = TextEditingController();
    this.viewModel.changelogControllers = [];

    this.viewModel.changelogs = [];

    // Add listeners for details textfield
    this.viewModel.titleController.addListener(() {
      updateHelperViewModel.titleText?.value =
          this.viewModel.titleController?.value?.text;
    });
    // this.viewModel.changelogController.addListener(() {
    //   // updateHelperViewModel.changelogText?.value = this.viewModel.changelogController?.value?.text;
    // });
  }

  // @override
  // Future onDestroy() async {
  //   this.viewModel.detailsFocus.dispose();
  //   this.viewModel.detailsController.dispose();
  //   super.onDestroy();
  // }

  addChangelogNote() {
    this.viewModel.changelogControllers.add(TextEditingController());
    this.viewModel.changelogs.add(
          EditableTextField.floating(
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: 14.0,
            ),
            textEditingController: this.viewModel.changelogControllers.last,
          ),
        );
    this.refreshView();
  }

  // Details text field stuff
  onDetailTextFieldTapped() {
    this.refreshView();
  }

  changeBackgroundColor(BuildContext context, EditorUpdateHelperPresenter presenter) {
    this.viewInterface.showColorPickerDialog(context, presenter);
  }

  // updateBackgroundColor() {
  //   this.viewInterface.getModel().backgroundColor.value = Colors.red;
  //   this.refreshView();
  // }

  String validateDetailsTextField(String currentValue) {
    if (currentValue.length <= 0) {
      return 'Please enter some text';
    }
    if (currentValue.length > 45) {
      return 'Maximum 45 characters';
    }
    return null;
  }
}
