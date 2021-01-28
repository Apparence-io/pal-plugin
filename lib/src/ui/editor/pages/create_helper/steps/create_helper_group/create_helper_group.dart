import 'package:flutter/material.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';
import 'package:pal/src/ui/editor/widgets/bordered_text_field.dart';
import 'package:pal/src/ui/editor/widgets/labeled_form.dart';

typedef HelperNameValidator = String Function(String value);

typedef TriggerTypeValidator = String Function(HelperTriggerTypeDisplay value);

typedef OnTriggerValueSelected = void Function(HelperTriggerTypeDisplay triggerType);

typedef OnChangedText = void Function(String value);

class CreateHelperGroup extends StatelessWidget {

  final HelperNameValidator helperNameValidator;
  final TriggerTypeValidator triggerTypeValidator;
  final OnTriggerValueSelected onTriggerValueSelected;
  final HelperTriggerTypeDisplay defaultTriggerType;
  final List<HelperTriggerTypeDisplay> triggerTypes;
  final OnChangedText onChangedNameText;
  final TextEditingController _nameController = TextEditingController();

  CreateHelperGroup({
    this.helperNameValidator,
    this.triggerTypeValidator,
    this.onTriggerValueSelected,
    this.defaultTriggerType,
    this.triggerTypes,
    this.onChangedNameText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
              items: triggerTypes.map(
                (element) =>  DropdownMenuItem<HelperTriggerTypeDisplay>(
                  value: element,
                  child: Text(element.description),
                )
              ).toList(),
              onChanged: onTriggerValueSelected,
              // items: _buildDropdownArray(),
            ),
          ),
        ],
      ),
    );
  }
}
