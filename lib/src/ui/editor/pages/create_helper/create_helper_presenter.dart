import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/pal_navigator_observer.dart';
import 'package:pal/src/services/editor/project/project_editor_service.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/setup_group/select_helper_group.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_theme/create_helper_theme_step_model.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step_model.dart';

class CreateHelperPresenter extends Presenter<CreateHelperModel, CreateHelperView> {

  final PackageVersionReader packageVersionReader;

  final PalRouteObserver routeObserver;

  final ProjectEditorService projectEditorService;

  CreateHelperPresenter(
    CreateHelperView viewInterface, {
    @required this.projectEditorService,
    @required this.routeObserver,
    @required this.packageVersionReader,
  }) : super(CreateHelperModel(), viewInterface);

  @override
  Future onInit() async {
    this.viewModel.step = ValueNotifier<int>(0);
    this.viewModel.isFormValid = false;
    this.viewModel.stepsTitle = [
      'Setup your group',
      'Setup your helper',
      'Choose your helper type',
      'Choose a theme',
    ];
    // Setup steps
    this.setupInfosStep();
    this.setupTypeStep();
    this.setupThemeStep();
  }

  ////////////////////////////////////////////////////////////////
  // STEP 1
  ////////////////////////////////////////////////////////////////

  Future<List<HelperGroupViewModel>> loadHelperGroup() async {
    if(viewModel.helperGroups != null) {
      return viewModel.helperGroups;
    }
    var res = [
      HelperGroupViewModel(groupId: "test1", title: "Introduction mock"),
      HelperGroupViewModel(groupId: "test2", title: "Second group mock"),
    ];
    viewModel.helperGroups = res;
    return Future.value(viewModel.helperGroups);
    // var currentPageRoute = await this.routeObserver.routeSettings.first;
    // return projectEditorService.getPageGroups(currentPageRoute.name)
    //   .catchError((error) => print("error $error"))
    //   .then((groupsEntity) {
    //     List<HelperGroupViewModel> res = [];
    //     groupsEntity.forEach((element) => res.add(
    //       HelperGroupViewModel(groupId: element.id, title: element.helpers?.first?.name))
    //     );
    //     viewModel.helperGroups = res;
    //     return viewModel.helperGroups;
    //   });
  }

  void onTapHelperGroupSelection(HelperGroupViewModel select) {
    viewModel.selectHelperGroup(select);
    checkValidStep();
    refreshView();
  }

  void onTapAddNewGroup() {
    this.viewModel.selectedHelperGroup = new HelperGroupViewModel(groupId: null, title: "");
    viewInterface.showNewHelperGroupForm();
  }

  ////////////////////////////////////////////////////////////////
  // STEP 1 - create new helper group
  ////////////////////////////////////////////////////////////////

  String checkHelperGroupName(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    } else if (value.length >= 45) {
      return 'Maximum 45 character allowed';
    }
    return null;
  }

  void onChangedHelperGroupName(String value) {
    this.viewModel.selectedHelperGroup.title = value;
    checkValidStep();
    refreshView();
  }

  void selectHelperGroupTrigger(HelperTriggerTypeDisplay triggerType) {
    this.viewModel.selectedTriggerType = triggerType;
  }

  ////////////////////////////////////////////////////////////////
  // STEP 2
  ////////////////////////////////////////////////////////////////

  Future<List<GroupHelperViewModel>> loadGroupHelpers() async {
    // MOCK
    var res = [
      GroupHelperViewModel(id: "3802832", title: "helper 1"),
      GroupHelperViewModel(id: "3802833", title: "helper 2"),
      GroupHelperViewModel(id: "3802834", title: "helper 3"),
      GroupHelperViewModel(id: "3802835", title: "helper 4"),
      GroupHelperViewModel(id: "3802836", title: "helper 5"),
    ];
    // put our new helper in the list and highlight it
    return res;
  }

  void onGroupReorder(List<GroupHelperViewModel> reorderedList) {
    viewModel.currentGroupHelpersList = reorderedList;
  }

  void onTapChangePosition() {
    viewInterface.showGroupHelpersPositions(loadGroupHelpers(), this.onGroupReorder);
  }

  ////////////////////////////////////////////////////////////////
  // STEP 3
  ////////////////////////////////////////////////////////////////

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
              key: type,
              description: getHelperTriggerTypeDescription(type),
            ),
          );
    });
    this.viewModel.selectedTriggerType = this.viewModel.triggerTypes?.first;
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

  incrementStep() async {
    if (this.viewModel.step.value >= this.viewModel.stepsTitle.length - 1) {
      var currentPageRoute = await this.routeObserver.routeSettings.first;
      this.viewInterface.launchHelperEditor(currentPageRoute.name, viewModel);
      return;
    }
    viewModel.step.value++;
    viewInterface.changeStep(viewModel.step.value);
    checkValidStep();
    refreshView();
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
        this.viewModel.isFormValid = this.viewModel.selectedHelperGroup != null
          && this.viewModel.selectedHelperGroup.title.isNotEmpty;
        break;
      case 1:
        this.viewModel.isFormValid = viewModel.infosForm != null && this.viewModel.infosForm.currentState != null
            ? this.viewModel.infosForm.currentState.validate()
            : false;
        break;
      case 2:
        this.viewModel.isFormValid = this.viewModel.selectedHelperType != null;
        break;
      case 3:
        this.viewModel.isFormValid = this.viewModel.selectedHelperTheme != null;
        break;
      default:
    }
  }


}
