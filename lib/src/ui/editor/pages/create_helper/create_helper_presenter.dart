import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_theme/create_helper_theme_step_model.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step_model.dart';

class CreateHelperPresenter
    extends Presenter<CreateHelperModel, CreateHelperView> {
  PackageVersionReader packageVersionReader;

  CreateHelperPresenter(
    CreateHelperView viewInterface, {
    @required this.packageVersionReader,
  }) : super(CreateHelperModel(), viewInterface);

  @override
  Future onInit() async {
    this.viewModel.nestedNavigationKey = GlobalKey<NavigatorState>();
    this.viewModel.step = ValueNotifier<int>(0);

    this.viewModel.isFormValid = false;
    this.viewModel.stepsTitle = [
      'Setup your helper',
      'Choose your helper type',
      'Choose a theme',
    ];

    // Setup steps
    this.setupInfosStep();
    this.setupTypeStep();
    this.setupThemeStep();
  }

  setupInfosStep() async {
    this.viewModel.infosForm = GlobalKey<FormState>();

    this.viewModel.helperNameController = TextEditingController();
    this.viewModel.minVersionController = TextEditingController();

    this.viewModel.isAppVersionLoading = false;

    // Trigger type dropdown
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

    readAppVersion();
  }

  readAppVersion() async {
    // Load app version
    this.viewModel.isAppVersionLoading = true;
    this.refreshView();
    await this.packageVersionReader.init();
    this.viewModel.appVersion = this.packageVersionReader.version;
    this.viewModel.minVersionController.text = this.viewModel.appVersion;
    this.viewModel.isAppVersionLoading = false;
    this.refreshView();
  }

  setupTypeStep() {
    this.viewModel.selectedHelperType = null;
    for (var helperType in CreateHelperThemeStepModel.cards.entries) {
      for (var card in helperType.value) {
        card.isSelected = false;
      }
    }
  }

  setupThemeStep() {
    this.viewModel.selectedHelperTheme = null;
    for (var card in CreateHelperTypesStepModel.cards) {
      card.isSelected = false;
    }
  }

  incrementStep() {
    if (this.viewModel.step.value >= this.viewModel.stepsTitle.length - 1) {
      this.viewInterface.launchHelperEditor(this.viewModel);
      return;
    }
    this.viewModel.step.value++;
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
            this.viewModel.infosForm.currentState.validate();
        break;
      case 1:
        this.viewModel.isFormValid = this.viewModel.selectedHelperType != null;
        break;
      case 2:
        this.viewModel.isFormValid = this.viewModel.selectedHelperTheme != null;
        break;
      default:
    }
  }
}
