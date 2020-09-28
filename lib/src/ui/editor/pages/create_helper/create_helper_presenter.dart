import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';

class CreateHelperPresenter
    extends Presenter<CreateHelperModel, CreateHelperView> {
  CreateHelperPresenter(
    CreateHelperView viewInterface,
  ) : super(CreateHelperModel(), viewInterface);

  @override
  Future onInit() async {
    this.viewModel.isFormValid = false;
    this.viewModel.stepsTitle = [
      'Setup your helper',
      'Choose your helper type',
      'Choose a theme',
    ];
    this.viewModel.nestedNavigationKey = GlobalKey<NavigatorState>();
    this.viewModel.formKey = GlobalKey<FormState>();

    this.viewModel.helperNameController = TextEditingController();

    this.viewModel.triggerTypes = [];
    HelperTriggerType.values.forEach((HelperTriggerType type) {
      this.viewModel.triggerTypes.add(
            HelperTriggerTypeDisplay(
              key: helperTriggerTypeToString(type),
              description: getHelperTriggerTypeDescription(type),
            ),
          );
    });
    this.viewModel.selectedTriggerType =
        this.viewModel.triggerTypes?.first?.key;
    this.viewModel.step = ValueNotifier<int>(0);
  }

  selectTriggerHelperType(String newValue) {
    this.viewModel.selectedTriggerType = newValue;
    this.refreshView();
  }

  incrementStep() {
    this.viewModel.step.value++;
    this.viewInterface.changeStep(
          this.viewModel.nestedNavigationKey,
          this.viewModel.step.value,
        );
    this.refreshView();
  }

  decrementStep() {
    if (this.viewModel.step.value <= 0) {
      return;
    }

    this.viewModel.step.value--;
    this.refreshView();
  }
}
