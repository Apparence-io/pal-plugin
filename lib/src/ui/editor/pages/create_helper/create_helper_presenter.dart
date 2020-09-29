import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';

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
    this.viewModel.formStep1Key = GlobalKey<FormState>();

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
    this.viewModel.isFormValid = false;
    this.viewInterface.changeStep(
          this.viewModel.nestedNavigationKey,
          this.viewModel.step.value,
        );
    this.checkValidStep();
    this.refreshView();
  }

  decrementStep() {
    if (this.viewModel.step.value <= 0) {
      return;
    }

    this.viewModel.step.value--;
    this.checkValidStep();
    this.refreshView();
  }

  void checkValidStep() {
    switch (this.viewModel.step.value) {
      case 0:
        this.viewModel.isFormValid =
            this.viewModel.formStep1Key.currentState.validate();
        break;
      case 1:
        this.viewModel.isFormValid = this.viewModel.selectedHelperType != null;
        break;
      case 2:
        this.viewModel.isFormValid = this.viewModel.selectedHelperType != null;
        break;
      default:
    }
  }
}
