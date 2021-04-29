import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/widgets/labeled_form.dart';
import 'package:pal/src/ui/editor/widgets/bordered_text_field.dart';

import '../../../../../../theme.dart';

class CreateHelperInfosStep extends StatelessWidget {

  final CreateHelperModel model;

  final CreateHelperPresenter presenter;

  final Function()? onFormChanged;

  final Function? onTapChangePosition;

  const CreateHelperInfosStep({
    Key? key,
    required this.model,
    required this.presenter,
    this.onFormChanged,
    this.onTapChangePosition
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          key: ValueKey('palCreateHelperScrollList'),
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  void _checkFormValid() {
    if (!model.isAppVersionLoading!) {
      model.isFormValid?.value = model.infosForm!.currentState!.validate();
      presenter.refreshView();
    }
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: model.infosForm,
      onChanged: _checkFormValid,
      autovalidateMode: AutovalidateMode.disabled,
      child: Wrap(
        runSpacing: 17.0,
        children: [
          LabeledForm(
            label: 'Name',
            widget: BorderedTextField(
              key: ValueKey('pal_CreateHelper_TextField_Name'),
              hintText: 'My new helper',
              controller: model.helperNameController,
              validator: _checkHelperName,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: _buildPositionButton(context),
          ),
          Text("Group position default is last.",
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
  // Check fields
  String? _checkHelperName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    } else if (value.length >= 45) {
      return 'Maximum 45 character allowed';
    }
    return null;
  }

  _buildPositionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        key: ValueKey('palHelperPositionNextButton'),
        borderSide: BorderSide(color: PalTheme.of(context)!.colors.dark!),
        child: Text(
          'Change position in group',
          style: TextStyle(
            color: PalTheme.of(context)!.colors.dark,
          ),
        ),
        color: PalTheme.of(context)!.colors.dark,
        onPressed: onTapChangePosition as void Function()?,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0,),
        ),
      ),
    );
  }
}
