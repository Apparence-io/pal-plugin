import 'package:flutter/material.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';
import 'package:pal/src/ui/editor/widgets/bordered_text_field.dart';
import 'package:pal/src/ui/editor/widgets/labeled_form.dart';


typedef TriggerTypeValidator = String Function(HelperTriggerTypeDisplay? value);

typedef OnVersionChanged = void Function(String value);

typedef OnFormChanged = void Function(bool state);

typedef OnTriggerValueSelected = void Function(HelperTriggerTypeDisplay? triggerType);

typedef OnChangedText = void Function(String value);

class CreateHelperGroup extends StatelessWidget {

  final TextFieldValidator helperNameValidator;
  final TriggerTypeValidator? triggerTypeValidator;
  final OnTriggerValueSelected onTriggerValueSelected;
  final HelperTriggerTypeDisplay defaultTriggerType;
  final List<HelperTriggerTypeDisplay>? triggerTypes;
  final OnChangedText onChangedNameText;
  final OnFormChanged onFormChanged;
  final TextFieldValidator minVersionValidator, maxVersionValidator;
  final String? minVersionInitialValue, maxVersionInitialValue;
  final OnVersionChanged minVersionChanged, maxVersionChanged;

  final GlobalKey<FormState> _formKey = GlobalKey();

  CreateHelperGroup({
    required this.helperNameValidator,
    required this.onFormChanged,
    required this.triggerTypeValidator,
    required this.onTriggerValueSelected,
    required this.defaultTriggerType,
    required this.triggerTypes,
    required this.onChangedNameText,
    required this.minVersionValidator,
    required this.maxVersionValidator,
    required this.minVersionInitialValue,
    required this.maxVersionInitialValue,
    required this.minVersionChanged,
    required this.maxVersionChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: () => onFormChanged(_formKey.currentState!.validate()),
          child: ListView(
            children: [
              LabeledForm(
                label: 'New helper group name',
                widget: BorderedTextField(
                  key: ValueKey('pal_CreateHelperGroup_TextField_Name'),
                  hintText: 'My new group name',
                  validator: helperNameValidator,
                  textCapitalization: TextCapitalization.sentences,
                  onValueChanged: onChangedNameText,
                ),
              ),
              SizedBox(height: 16),
              LabeledForm(
                label: 'Trigger type',
                widget: DropdownButtonFormField<HelperTriggerTypeDisplay>(
                  key: ValueKey('pal_CreateHelperGroup_Dropdown_Type'),
                  validator: triggerTypeValidator,
                  value: defaultTriggerType,
                  items: triggerTypes!.map(
                    (element) =>  DropdownMenuItem<HelperTriggerTypeDisplay>(
                      value: element,
                      child: Text(element.description!),
                    )
                  ).toList(),
                  onChanged: onTriggerValueSelected,
                  // items: _buildDropdownArray(),
                ),
              ),
              SizedBox(height: 16),
              LabeledForm(
                label: 'Minimum app version',
                widget: BorderedTextField(
                  key: ValueKey('pal_CreateHelper_TextField_MinimumVersion'),
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  initialValue: minVersionInitialValue,
                  onValueChanged: minVersionChanged,
                  validator: minVersionValidator,
                  isLoading: false,
                ),
              ),
              SizedBox(height: 16),
              LabeledForm(
                label: 'Maximum app version',
                widget: BorderedTextField(
                  key: ValueKey('pal_CreateHelper_TextField_MaximumVersion'),
                  textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
                  initialValue: maxVersionInitialValue,
                  hintText: "Max version number or empty for latest version",
                  onValueChanged: maxVersionChanged,
                  validator: maxVersionValidator,
                  isLoading: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
