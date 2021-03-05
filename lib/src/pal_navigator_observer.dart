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

  void changePage(String route, {Map<String, String> arguments}) {
    if(route != null && route.isNotEmpty) {
      _notify(RouteSettings(name: route, arguments: arguments));
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if(route.settings == null || route.settings.name == null) {
      debugPrint("Pal Warning ------------------");
      debugPrint("You pushed a route without any name");
      debugPrint("If you want to use pal on this page please push a route with a settingsName ");
      debugPrint("or using pushNamed so we can recognize this page using this name as identifier");
      debugPrint("   Navigator.of(context).push(");
      debugPrint("       MaterialPageRoute(builder: (context) => MyPage(), settings: RouteSettings(name: '/myPageName'))");
      debugPrint("   );");
      debugPrint("------------------------------");
    }
    if (route is PageRoute) {
      _notify(route.settings);
      _notifyRoute(route);
    }
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
