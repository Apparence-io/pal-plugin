import 'package:flutter/material.dart';
import 'package:palplugin/palplugin.dart';
import 'package:rxdart/rxdart.dart';

class PalRouteObserver {

  Stream<RouteSettings> get stream => throw "not implemented yet";
}


class PalNavigatorObserver extends RouteObserver<PageRoute<dynamic>> implements PalRouteObserver {

  static PalNavigatorObserver _instance;

  Subject<RouteSettings> _route = BehaviorSubject() ;

  PalNavigatorObserver._();

  factory PalNavigatorObserver.instance() {
    if(_instance == null) {
      _instance = PalNavigatorObserver._();
    }
    return _instance;
  }

  _notify(RouteSettings route) => _route.add(route);

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _notify(route.settings);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _notify(newRoute.settings);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _notify(previousRoute.settings);
    }
  }

  Stream<RouteSettings> get stream => _route.asBroadcastStream();
}
