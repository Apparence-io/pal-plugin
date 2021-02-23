import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/services/editor/groups/group_service.dart';

import 'group_details.dart';
import 'group_details_model.dart';

class GroupDetailsPresenter
    extends Presenter<GroupDetailsModel, GroupDetailsView> {
  final EditorHelperGroupService groupService;

  GroupDetailsPresenter(
      GroupDetailsModel viewModel, GroupDetailsView viewInterface,
      {@required this.groupService})
      : super(viewModel, viewInterface);

  @override
  void onInit() {
    super.onInit();

    // INIT
    this.viewModel.loading = true;
    this.viewModel.helpers = ValueNotifier(null);
    // INIT

    this.groupService.getGroupDetails(this.viewModel.groupId).then((group) {
      this.viewModel.groupModel = GroupModel.from(group);
      this.viewModel.loading = false;
    });

    this.groupService.getGroupHelpers(this.viewModel.groupId).then((res) {
      var list = <HelperModel>[];
      res.forEach((helper) => list.add(HelperModel.from(helper)));
      this.viewModel.helpers.value = list;
    });
  }

  void onTriggerChange(HelperTriggerType val) {
    this.viewModel.groupModel.triggerType = val;
    this.refreshView();
  }
}
