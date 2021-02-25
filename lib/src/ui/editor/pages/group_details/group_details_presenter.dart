import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/services/editor/groups/group_service.dart';

import 'group_details.dart';
import 'group_details_model.dart';

// TODO : Send Server requests
class GroupDetailsPresenter
    extends Presenter<GroupDetailsPageModel, GroupDetailsView> {
  final EditorHelperGroupService groupService;

  GroupDetailsPresenter(
      GroupDetailsPageModel viewModel, GroupDetailsView viewInterface,
      {@required this.groupService})
      : super(viewModel, viewInterface);

  @override
  void onInit() {
    super.onInit();

    // INIT
    // *STATE
    this.viewModel.loading = true;
    this.viewModel.helpers = ValueNotifier(null);
    this.viewModel.page = PageStep.DETAILS;
    this.viewModel.canSave = ValueNotifier(false);
    this.viewModel.locked = false;

    // *CONTROLLERS
    this.viewModel.groupMaxVerController = TextEditingController();
    this.viewModel.groupMinVerController = TextEditingController();
    this.viewModel.groupNameController = TextEditingController();
    // INIT

    // FETCHING GROUP INFO
    this.groupService.getGroupDetails(this.viewModel.groupId).then((group) {
      this.viewModel.groupModel = GroupModel.from(group);

      // ASSIGNING INITIALS VALUES TO CONTROLLERS
      this.viewModel.groupMaxVerController.text =
          this.viewModel.groupModel.maxVer;
      this.viewModel.groupMinVerController.text =
          this.viewModel.groupModel.minVer;
      this.viewModel.groupNameController.text = this.viewModel.groupModel.name;
      this.viewModel.groupTriggerValue = this.viewModel.groupModel.triggerType;

      // ENDING LOADING
      this.viewModel.loading = false;
      this.refreshView();
    });

    this.groupService.getGroupHelpers(this.viewModel.groupId).then((res) {
      var list = <HelperModel>[];
      res.forEach((helper) => list.add(HelperModel.from(helper)));
      this.viewModel.helpers.value = list;
    });
  }

  // SAVE NEW VALUES AND SEND TO SERVER
  void save() {
    if(!this.viewModel.locked){

    }
  }

  // CONTROLLERS SUBMIT CHECKS && VALIDATOR
  onNewTrigger(HelperTriggerType newTrigger) {
    this.viewModel.groupTriggerValue = newTrigger;
    this.viewModel.canSave.value = true;
  }

  void onNameSubmit(String val) {
    if (val != this.viewModel.groupModel.name) this.updateState();
  }

  void onMinVerSubmit(String val) {
    if (val != this.viewModel.groupModel.minVer) this.updateState();
  }

  void onMaxVerSubmit(String val) {
    if (val.isNotEmpty && val != this.viewModel.groupModel.maxVer)
      this.updateState();
  }

  String validateVersion(String val) {
    if (val.contains(new RegExp(
        r'^(?<version>(?<major>0|[1-9][0-9]*)\.(?<minor>0|[1-9][0-9]*)\.(?<patch>0|[1-9][0-9]*))((\+|\-).+)?$'))) {
      this.viewModel.locked = false;
      return null;
    }
    this.viewModel.locked = true;
    return 'Invalid version format';
  }

  String validateName(String val) {
    if (val.isNotEmpty) {
      this.viewModel.locked = false;
      return null;
    }
    this.viewModel.locked = true;
    return 'Name is required';
  }

  // STATE CHANGES
  void goToHelpersList() {
    this.viewModel.page = PageStep.HELPERS;
    this.refreshView();
  }

  void goToGroupDetails() {
    this.viewModel.page = PageStep.DETAILS;
    this.refreshView();
  }

  void updateState() {
    this.viewModel.canSave.value = !this.viewModel.locked &&
        this.viewModel.formKey.currentState.validate();
  }
}
