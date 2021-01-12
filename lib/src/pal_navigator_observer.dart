import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PalRouteObserver {

  Stream<RouteSettings> get routeSettings => throw "not implemented yet";
}


class PalNavigatorObserver extends RouteObserver<PageRoute<dynamic>> implements PalRouteObserver {

  static PalNavigatorObserver _instance;

  Subject<RouteSettings> _routeSettingsSubject = BehaviorSubject();
  
  Subject<PageRoute> _routeSubject = BehaviorSubject();

  PalNavigatorObserver._();

  factory PalNavigatorObserver.instance() {
    if(_instance == null) {
      _instance = PalNavigatorObserver._();
    }
    return _instance;
  }

  _notify(RouteSettings route) => _routeSettingsSubject.add(route);

  _notifyRoute(PageRoute route) => _routeSubject.add(route);

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
      if (route is PageRoute) {
        _notify(route.settings);
        _notifyRoute(route);
      }
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    // });
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _notify(newRoute.settings);
      _notifyRoute(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _notify(previousRoute.settings);
      _notifyRoute(previousRoute);
    }
  }

  Stream<RouteSettings> get routeSettings => _routeSettingsSubject.asBroadcastStream();
  
  Stream<PageRoute> get route => _routeSubject.asBroadcastStream();
}
