import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/pal.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/groups/group_service.dart';

import 'page_group_list.dart';
import 'page_group_list_model.dart';

/// [PageGroupsListPresenter]
/// business logic for page group list 
class PageGroupsListPresenter extends Presenter<PageGroupsListViewModel, PageGroupsListView> {

  final EditorHelperGroupService helperGroupService;
  final PalNavigatorObserver navigatorObserver;
  
  PageGroupsListPresenter({
    EditorInjector editorInjector,
    PageGroupsListView viewInterface,
    this.navigatorObserver,
  }) : this.helperGroupService = editorInjector.helperGroupService, 
    super(PageGroupsListViewModel(), viewInterface);

  @override
  void onInit() async {
    viewModel.groups = Map();
    viewModel.isLoading = true;
    viewModel.errorMessage = null;
    RouteSettings route = await navigatorObserver.routeSettings.first;
    // TODO show error if route name is empty
    // TODO show current page route path
    helperGroupService.getPageGroups(route.name)
      .catchError((err) {
        viewModel.errorMessage = "Server error while loading data...";
        viewModel.isLoading = false;
        refreshView();
      })
      .then((groupsEntities) {
        if(viewModel.errorMessage != null) 
          return;
        if(viewModel.groups.isNotEmpty)
          viewModel.groups.clear();
        groupsEntities.forEach((element) {
          if(!viewModel.groups.containsKey(element.triggerType)) {
            viewModel.groups.putIfAbsent(element.triggerType, () => List());
          }
          viewModel.groups[element.triggerType]
            .add(GroupItemViewModel(
              element.name, 
              _formatDate(element.creationDate), 
              _formatVersion(element.minVersion, element.maxVersion),
              element.id
            ));
        });
        viewModel.isLoading = false;
        refreshView();
      });
  }

  void onClickClose() => viewInterface.closePage();

  Future<void> onClickAddHelper() async {
    RouteSettings route = await navigatorObserver.routeSettings.first;
    await viewInterface.closePage();
    viewInterface.navigateCreateHelper(route.name);
  }

  String _formatDate(DateTime date) => "Created on ${date.day}/${date.month}/${date.year}"; 

  String _formatVersion(String minVersion, String maxVersion) => "$minVersion - ${maxVersion ?? 'last'}"; 

}