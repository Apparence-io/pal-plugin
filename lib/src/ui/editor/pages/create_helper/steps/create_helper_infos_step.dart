import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/labeled_form.dart';
import 'package:palplugin/src/ui/shared/widgets/bordered_text_field.dart';

class CreateHelperInfosStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CreateHelperModel model;
  final CreateHelperPresenter presenter;
  final TextEditingController helperNameController;
  final Function() onFormChanged;

  const CreateHelperInfosStep({
    Key key,
    @required this.formKey,
    @required this.model,
    @required this.presenter,
    @required this.helperNameController,
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
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              _buildForm(),
              SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Image.asset(
                  'packages/palplugin/assets/images/create_helper.png',
                  key: ValueKey('palCreateHelperImage'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      onChanged: onFormChanged,
      child: Wrap(
        runSpacing: 17.0,
        children: [
          LabeledForm(
            label: 'Name',
            widget: BorderedTextField(
              key: ValueKey('palCreateHelperTextFieldName'),
              hintText: 'My new helper',
              controller: helperNameController,
              validator: (String value) =>
                  (value.isEmpty) ? 'Please enter a name' : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledForm(
                label: 'Trigger type',
                widget: DropdownButtonFormField(
                  key: ValueKey('palCreateHelperTypeDropdown'),
                  validator: (String value) =>
                      (value.isEmpty) ? 'Please select a type' : null,
                  value: model.triggerTypes.first.key,
                  onChanged: presenter.selectTriggerHelperType,
                  items: _buildDropdownArray(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
}
