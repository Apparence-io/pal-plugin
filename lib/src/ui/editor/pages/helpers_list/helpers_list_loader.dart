import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/database/entity/pageable.dart';
import 'package:pal/src/pal_navigator_observer.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/editor/page/page_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalLoader {

  final PageEditorService _pageService;
  final EditorHelperService _helperService;
  final PalRouteObserver _routeObserver;
  final _helpersOffset = 20;
  Pageable<HelperEntity> _pageable;

  HelpersListModalLoader(
    this._pageService,
    this._helperService,
    this._routeObserver
  );

  Future<HelpersListModalModel> load() async {
    var resViewModel = HelpersListModalModel();

    RouteSettings route = await _routeObserver.routeSettings.first;
    PageEntity page = await getPage(route);
    if (page != null && page.id.isNotEmpty) {
      resViewModel.pageId = page.id;
      resViewModel.pageRouteName = page.route;
      resViewModel.helpers = await this.loadMore(page?.id);
    }
    return resViewModel;
  }

  Future<List<HelperEntity>> loadMore(String pageId) {
    return _pageable != null && _pageable.last
        ? Future.value([])
        : this
            ._helperService.getPage(
              pageId,
              _pageable == null ? 0 : ++_pageable.pageNumber,
              _helpersOffset,
            ).then(
              (res) {
                _pageable = res;
                return this._pageable.entities.toList();
            },
          );
  }

  Future<PageEntity> getPage(RouteSettings route) async {
    if (route == null || route.name == null || route.name.length <= 0) {
      return Future.value();
    }
    return this._pageService.getPage(route.name).then((resPage) => resPage);
  }

}
