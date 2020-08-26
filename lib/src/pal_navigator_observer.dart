import 'package:flutter/material.dart';
import 'package:palplugin/palplugin.dart';

// TODO: Pal controller need to be an instanciated class & not a Singleton page ?
class PalNavigatorObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      PalController.instance.routeName.value = route.settings.name;
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      PalController.instance.routeName.value = newRoute.settings.name;
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      PalController.instance.routeName.value = previousRoute.settings.name;
    }
  }
}
