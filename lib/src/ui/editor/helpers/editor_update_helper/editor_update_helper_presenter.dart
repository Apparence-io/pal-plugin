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
    this.viewModel.thanksController = TextEditingController();
    this.viewModel.changelogsControllers = [];

    this.viewModel.changelogsTextfieldWidgets = [];

    // Add listeners for details textfield
    this.viewModel.titleController.addListener(() {
      updateHelperViewModel.titleText?.value =
          this.viewModel.titleController?.value?.text;
    });

    this.addChangelogNote();
  }

  @override
  Future onDestroy() async {
    this.viewModel.titleController?.dispose();
    this.viewModel.thanksController?.dispose();
    // Dismiss all changelogs controllers
    for (TextEditingController controller in this.viewModel.changelogsControllers) {
      controller?.dispose();
    }
    super.onDestroy();
  }

  addChangelogNote() {
    var changelogController = TextEditingController();

    String hintText;
    if (this.viewModel.changelogsTextfieldWidgets.length <= 0) {
      hintText = 'Enter your first update line here...';
    } else {
      hintText = 'Enter update line here...';
    }

    UpdateHelperViewModel viewModel = this.viewInterface.getModel();
    viewModel.changelogFontColor?.value?.add(Colors.black87);
    viewModel.changelogFontSize?.value?.add(14.0);
    viewModel.changelogText?.value?.add(hintText);

    this.viewModel.changelogsControllers.add(changelogController);
    this.viewModel.changelogsTextfieldWidgets.add(
          EditableTextField.floating(
            hintText: viewModel.changelogText?.value?.last,
            textStyle: TextStyle(
              color: viewModel.changelogFontColor?.value?.last,
              fontSize: viewModel.changelogFontSize?.value?.last,
            ),
            textEditingController: changelogController,
          ),
        );
    changelogController.addListener(() {
      updateHelperViewModel.changelogText?.value?.last = changelogController?.value?.text;
    });
    this.refreshView();
  }

  changeBackgroundColor(BuildContext context, EditorUpdateHelperPresenter presenter) {
    this.viewInterface.showColorPickerDialog(context, presenter);
  }

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
