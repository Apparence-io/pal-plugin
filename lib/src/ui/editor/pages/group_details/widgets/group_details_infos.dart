// GROUP DETAILS INFO
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/widgets/bordered_text_field.dart';
import 'package:pal/src/ui/editor/widgets/labeled_form.dart';

import '../group_details_model.dart';
import '../group_details_presenter.dart';

class GroupDetailsInfo extends StatelessWidget {
  final GroupDetailsPageModel model;
  final GroupDetailsPresenter presenter;

  const GroupDetailsInfo(
    this.presenter,
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Opacity(
              opacity: model.loading ? .2 : 1,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailsTextField(
                      key: ValueKey('GroupNameField'),
                      label: 'Group name',
                      hint: 'Name',
                      validator: presenter.validateName,
                      controller: model.groupNameController,
                      onFieldSubmitted: presenter.onNameSubmit,
                    ),
                    Divider(
                      height: 16,
                    ),
                    DetailsSelectField(
                      key: ValueKey('TriggerTypeField'),
                      label: 'Trigger type',
                      initialValue: model.groupTriggerValue,
                      newTriggerCallBack: presenter.onNewTrigger,
                    ),
                    Divider(
                      height: 16,
                    ),
                    DetailsTextField(
                      key: ValueKey('MinVersionField'),
                      label: 'Minimum version',
                      validator: presenter.validateVersion,
                      hint: 'Choose a minimum version',
                      keyboardType: TextInputType.number,
                      controller: model.groupMinVerController,
                      onFieldSubmitted: presenter.onMinVerSubmit,
                    ),
                    Divider(
                      height: 16,
                    ),
                    DetailsTextField(
                      key: ValueKey('MaxVersionField'),
                      label: 'Maximum version',
                      validator: (val) {
                        if (val.isEmpty) return null;
                        return presenter.validateVersion(val);
                      },
                      hint: 'Default set to latest',
                      keyboardType: TextInputType.number,
                      controller: model.groupMaxVerController,
                      onFieldSubmitted: presenter.onMaxVerSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!model.loading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ValueListenableBuilder(
                valueListenable: model.canSave,
                builder: (context, value, child) => ElevatedButton(
                    key: ValueKey('saveButton'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => PalTheme.of(context).colors.color1),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                    onPressed: value ? presenter.save : null,
                    child: child),
                child: Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.w100),
                ),
              ),
            ),
          Divider(
            height: 8,
          ),
          if (model.loading)
            LinearProgressIndicator(
              value: null,
              minHeight: 5,
            ),
        ],
      ),
    );
  }
}

class DetailsTextField extends StatelessWidget {
  final String label, hint;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String Function(String) validator;
  final Function(String) onFieldSubmitted;

  const DetailsTextField(
      {Key key,
      this.label,
      this.controller,
      this.hint,
      this.onFieldSubmitted,
      this.validator,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LabeledForm(
      label: this.label,
      widget: BorderedTextField(
        textInputType: this.keyboardType,
        autovalidate: true,
        validator: this.validator,
        onFieldSubmitted: this.onFieldSubmitted,
        isLoading: false,
        hintText: this.hint,
        controller: this.controller,
      ),
    );
  }
}

class DetailsSelectField extends StatelessWidget {
  final String label;
  final HelperTriggerType initialValue;
  final Function(HelperTriggerType newTrigger) newTriggerCallBack;

  const DetailsSelectField(
      {Key key,
      this.label,
      @required this.newTriggerCallBack,
      @required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LabeledForm(
      label: this.label,
      widget: DropdownButtonFormField<HelperTriggerType>(
        value: this.initialValue,
        items: HelperTriggerType.values
            .map((element) => DropdownMenuItem<HelperTriggerType>(
                  value: element,
                  child: Text(getHelperTriggerTypeDescription(element)),
                ))
            .toList(),
        onChanged: (val) {
          if (val != this.initialValue) this.newTriggerCallBack(val);
        },
      ),
    );
  }
}
// GROUP DETAILS INFO
