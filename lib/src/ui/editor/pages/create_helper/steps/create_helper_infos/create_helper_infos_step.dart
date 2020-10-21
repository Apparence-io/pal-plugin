import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/labeled_form.dart';
import 'package:palplugin/src/ui/editor/widgets/bordered_text_field.dart';

class CreateHelperInfosStep extends StatelessWidget {
  final CreateHelperModel model;
  final CreateHelperPresenter presenter;
  final Function() onFormChanged;

  const CreateHelperInfosStep({
    Key key,
    @required this.model,
    @required this.presenter,
    this.onFormChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        key: ValueKey('palCreateHelperScrollList'),
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  void _checkFormValid() {
    model.isFormValid = model.infosForm.currentState.validate();
    presenter.refreshView();
  }

  Widget _buildForm() {
    return Form(
      key: model.infosForm,
      onChanged: _checkFormValid,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Wrap(
        runSpacing: 17.0,
        children: [
          LabeledForm(
            label: 'Name',
            widget: BorderedTextField(
              key: ValueKey('palCreateHelperTextFieldName'),
              hintText: 'My new helper',
              controller: model.helperNameController,
              validator: _checkHelperName,
            ),
          ),
          LabeledForm(
            label: 'Trigger type',
            widget: DropdownButtonFormField(
              key: ValueKey('palCreateHelperTypeDropdown'),
              validator: _checkHelperTriggerType,
              value: model.triggerTypes.first.key,
              onChanged: _onTriggerTypeChanged,
              items: _buildDropdownArray(),
            ),
          ),
          LabeledForm(
            label: 'Minimum version',
            widget: BorderedTextField(
              key: ValueKey('pal_CreateHelper_TextField_MinimumVersion'),
              hintText: '1.0.0',
              textInputType: TextInputType.numberWithOptions(decimal: true),
              controller: model.minVersionController,
              validator: _checkValidVersion,
            ),
          ),
        ],
      ),
    );
  }

  _onTriggerTypeChanged(String newValue) {
    model.selectedTriggerType = newValue;
    presenter.refreshView();
  }

  List<DropdownMenuItem<String>> _buildDropdownArray() {
    List<DropdownMenuItem<String>> dropdownArray = [];
    model.triggerTypes.forEach((element) {
      dropdownArray.add(DropdownMenuItem<String>(
        value: element.key,
        child: Text(element.description),
      ));
    });
    return dropdownArray;
  }

  // Check fields
  String _checkHelperName(String value) {
    return (value.isEmpty) ? 'Please enter a name' : null;
  }

  String _checkHelperTriggerType(String value) {
    return (value.isEmpty) ? 'Please select a type' : null;
  }

  String _checkValidVersion(String value) {
    final String pattern = r'^\d+(\.\d+){0,2}$';
    final RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter a version';
    } else {
      if (!regExp.hasMatch(value))
        return 'Please enter a valid version';
      else
        return null;
    }
  }
}
