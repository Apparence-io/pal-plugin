import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/groups/group_service.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/editor/versions/version_editor_service.dart';

import 'group_details.dart';
import 'group_details_model.dart';

class GroupDetailsPresenter
    extends Presenter<GroupDetailsPageModel, GroupDetailsView> {
  final EditorHelperGroupService groupService;
  final EditorHelperService? helperService;
  final VersionEditorService versionService;

  GroupDetailsPresenter(
      GroupDetailsPageModel viewModel, GroupDetailsView viewInterface,
      {this.helperService,
      required this.groupService,
      required this.versionService})
      : super(viewModel, viewInterface);

  @override
  void onInit() {
    super.onInit();

    // INIT
    // *STATE
    this.viewModel.loading = true;
    this.viewModel.locked = false;
    this.viewModel.editorMode = false;
    this.viewModel.helpers = ValueNotifier(null);
    this.viewModel.canSave = ValueNotifier(false);
    this.viewModel.page = this.viewModel.startPage ?? PageStep.DETAILS;
    this.viewModel.pageController =
        PageController(initialPage: this.viewModel.page!.index);

    // *CONTROLLERS
    this.viewModel.groupMaxVerController = TextEditingController();
    this.viewModel.groupMinVerController = TextEditingController();
    this.viewModel.groupNameController = TextEditingController();
    // INIT

    // FETCHING GROUP INFO
    this.groupService.getGroupDetails(this.viewModel.groupId).then((group) {
      this.viewModel.groupModel = GroupModel.from(group);

      // ASSIGNING INITIALS VALUES TO CONTROLLERS
      this.viewModel.groupMaxVerController!.text =
          this.viewModel.groupModel.maxVer!;
      this.viewModel.groupMinVerController!.text =
          this.viewModel.groupModel.minVer!;
      this.viewModel.groupNameController!.text = this.viewModel.groupModel.name!;
      this.viewModel.groupTriggerValue = this.viewModel.groupModel.triggerType;

      // ENDING LOADING
      this.viewModel.loading = false;
      this.refreshView();
    });

    this.groupService.getGroupHelpers(this.viewModel.groupId).then((res) {
      var list = <HelperModel>[];
      res.forEach((helper) => list.add(HelperModel.from(helper)));
      this.viewModel.helpers!.value = list;
    });
  }

  // SERVER CALLS [SAVE,DELETE]
  void save() {
    if (!this.viewModel.locked!) {
      this.viewModel.locked = true;
      this.viewModel.loading = true;
      this.refreshView();
      Future.wait([
        this
            .versionService
            .getOrCreateVersionId(this.viewModel.groupMinVerController!.text),
        this.viewModel.groupMaxVerController!.text.isNotEmpty
            ? this
                .versionService
                .getOrCreateVersionId(this.viewModel.groupMaxVerController!.text)
            : Future.value(null),
      ]).catchError((err) {
        this.viewModel.loading = false;
        this.viewModel.locked = false;
        this.refreshView();
        this.viewInterface.showError();
      }).then((res) {
        HelperGroupUpdate updated = HelperGroupUpdate(
          id: this.viewModel.groupId,
          maxVersionId: res[1],
          minVersionId: res[0],
          name: this.viewModel.groupNameController!.text,
          type: this.viewModel.groupTriggerValue,
        );
        this.groupService.updateGroup(updated).then((res) {
          this.viewModel.loading = false;
          this.viewModel.locked = false;
          this.refreshView();
          this.viewInterface.showSucess('Group updated.');
        }).catchError((err) {
          this.viewModel.loading = false;
          this.viewModel.locked = false;
          this.refreshView();
          this.viewInterface.showError();
        });
      });
    }
  }

  void deleteGroup() {
    if (!this.viewModel.locked!) {
      this.viewModel.loading = true;
      this.refreshView();
      this.groupService.deleteGroup(this.viewModel.groupId).then((done) {
        this.viewInterface.pop();
      }).catchError((err) {
        this.viewModel.loading = false;
        this.refreshView();
        this.viewInterface.showError();
      });
    }
  }

  // CONTROLLERS SUBMIT CHECKS && VALIDATOR
  onNewTrigger(HelperTriggerType? newTrigger) {
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
    if (val != this.viewModel.groupModel.maxVer) this.updateState();
  }

  String? validateVersion(String ?val) {
    if (val!.contains(new RegExp(
        r'^(?<version>(?<major>0|[1-9][0-9]*)\.(?<minor>0|[1-9][0-9]*)\.(?<patch>0|[1-9][0-9]*))$'))) {
      this.viewModel.locked = false;
      return null;
    }
    this.viewModel.locked = true;
    return 'Invalid version format';
  }

  String? validateName(String? val) {
    if (val != null && val.isNotEmpty) {
      this.viewModel.locked = false;
      return null;
    }
    this.viewModel.locked = true;
    return 'Name is required';
  }

  // STATE CHANGES
  void goToHelpersList() {
    if (!this.viewModel.loading!) {
      this.viewModel.page = PageStep.HELPERS;
      this.viewModel.pageController!.animateToPage(1,
          curve: Curves.easeOut, duration: Duration(milliseconds: 250));
      this.refreshView();
    }
  }

  void goToGroupDetails() {
    if (!this.viewModel.loading!) {
      this.viewModel.page = PageStep.DETAILS;
      this.viewModel.pageController!.animateToPage(0,
          curve: Curves.easeOut, duration: Duration(milliseconds: 250));
      this.refreshView();
    }
  }

  void updateState() {
    this.viewModel.canSave.value = !this.viewModel.locked! &&
        this.viewModel.formKey.currentState!.validate();
  }

  // HELPERS ACTIONS / PREVIEW / EDIT / DELETE

  void previewHelper(String id) {
    this.viewInterface.previewHelper(id);
  }

  Future deleteHelper(String id) {
    this.viewModel.loading = true;
    this.refreshView();
    return this.helperService!.deleteHelper(id).then((done) {
      this.viewModel.helpers!.value = this
          .viewModel
          .helpers!
          .value!
          .where((helper) => helper.helperId != id)
          .toList();
      this.viewModel.loading = false;
      this.viewInterface.showSucess('Helper deleted.');
      this.refreshView();
    }).catchError((err) {
      this.viewModel.loading = false;
      this.refreshView();
      this.viewInterface.showError();
    });
  }

  void editHelper(String helperId, HelperType type) {
    this.viewModel.editorMode = true;
    this.refreshView();
    this.viewInterface.showEditor(
        this.viewModel.routeName, helperId, this.viewModel.groupId, type);
  }

  void onEditDone() {
    this.viewModel.editorMode = false;
    this.refreshView();
  }
}
