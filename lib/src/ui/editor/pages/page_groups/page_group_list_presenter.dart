import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/pal.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/groups/group_service.dart';
import 'package:pal/src/services/editor/page/page_editor_service.dart';

import 'page_group_list.dart';
import 'page_group_list_model.dart';

/// [PageGroupsListPresenter]
/// business logic for page group list
class PageGroupsListPresenter
    extends Presenter<PageGroupsListViewModel, PageGroupsListView?> {
  final EditorHelperGroupService helperGroupService;
  final PalNavigatorObserver? navigatorObserver;
  final PageEditorService pageService;

  // PAGE STATE
  String? pageId;

  PageGroupsListPresenter({
    required EditorInjector editorInjector,
    PageGroupsListView? viewInterface,
    this.navigatorObserver,
  })  : this.helperGroupService = editorInjector.helperGroupService,
        this.pageService = editorInjector.pageEditorService,
        super(PageGroupsListViewModel(), viewInterface);

  @override
  void onInit() async {
    viewModel.groups = Map();
    viewModel.isLoading = true;
    this.refreshView();
    viewModel.errorMessage = null;
    RouteSettings route = await navigatorObserver!.routeSettings.first;
    this.viewModel.route = route.name;
    // TODO show current page route path
    try {
      this.pageId = await this.pageService.getOrCreatePageId(route.name);
      var groupsEntities = await helperGroupService.getPageGroups(pageId);
      if (viewModel.errorMessage != null) return;//
      if (viewModel.groups.isNotEmpty) viewModel.groups.clear();
      groupsEntities.forEach((element) {
        if (!viewModel.groups.containsKey(element.triggerType)) {
          viewModel.groups.putIfAbsent(element.triggerType, () => []);
        }
        viewModel.groups[element.triggerType]!.add(GroupItemViewModel(
            element.name,
            _formatDate(element.creationDate!),
            _formatVersion(element.minVersion, element.maxVersion),
            element.id));
      });
      viewModel.isLoading = false;
      refreshView();
    } catch(err, stack) {
      viewModel.errorMessage = "Server error while loading data...";
      debugPrintStack(stackTrace: stack);
      viewModel.isLoading = false;
      refreshView();
    }
  }

  void onClickClose() {
    this.viewInterface!.changeBubbleState(true);
    viewInterface!.closePage();
  }

  Future<void> onClickAddHelper() async {
    if (!this.viewModel.isLoading!) {
      viewInterface!.navigateCreateHelper(this.pageId);
    }
  }

  String _formatDate(DateTime date) =>
      "Created on ${date.day}/${date.month}/${date.year}";

  String _formatVersion(String? minVersion, String? maxVersion) =>
      "$minVersion - ${maxVersion ?? 'last'}";

  Future onClickSettings() {
    return this.viewInterface!.openAppSettingsPage();
  }
}
