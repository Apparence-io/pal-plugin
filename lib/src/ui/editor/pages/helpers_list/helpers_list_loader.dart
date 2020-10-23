import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_service.dart';
import 'package:palplugin/src/services/page_server.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalLoader {

  final PageService _pageService;
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

    String pageId = await getPageId();
    if (pageId != null && pageId.length > 0) {
      resViewModel.pageId = pageId;
      resViewModel.helpers = await this.loadMore(pageId);
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

  Future<String> getPageId() async {
    RouteSettings route = await _routeObserver.routeSettings.first;
    if (route == null || route.name.length <= 0) {
      return Future.value();
    }
    return this._pageService.getPage(route.name).then(
      (resPages) {
        String routeId;
        if (resPages != null && resPages.totalElements > 0) {
          routeId = resPages.entities[0].id;
        }
        return routeId;
      },
    );
  }
}
