import 'package:flutter/material.dart';
import 'package:pal_example/ui/pages/home/home_page.dart';
import 'package:pal_example/ui/pages/route1/route1_page.dart';
import 'package:pal_example/ui/pages/route2/route2_page.dart';
import 'package:palplugin/palplugin.dart';

import 'router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Pal.fromRouterApp(
      editorModeEnabled: true,
      navigatorKey: _navigatorKey,
      appToken: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5YzgyMzlmOS1iMWVjLTQ3YTItYjg2Mi1mYTI3NGM0N2UwNmIiLCJ0eXBlIjoiUFJPSkVDVCIsImlhdCI6MTU5ODUyODk0OH0.4EAyk2jW4jkNlZbtosWzGDyY-U6INfO7XxoWX6PPU0c',
      child: MaterialApp.router(
        routeInformationParser: MyInformationParser(),
        routerDelegate:  MyRouterDelegate(_navigatorKey)
      ),
    );
  }

}


abstract class MyRoutePath {}

class MyInformationParser extends RouteInformationParser<MyRoutePath> {
  @override
  Future<MyRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    print("parseRouteInformation ${routeInformation.location}");
  }
}

class MyRouterDelegate extends RouterDelegate<MyRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath>{

  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate(this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [PalNavigatorObserver.instance()],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
      onGenerateRoute: route,
      initialRoute: "/",
      pages: [
        MaterialPage(
          key: ValueKey('/'),
          child: HomePage(),
        ),
      ],
    );
  }

  @override
  Future<void> setNewRoutePath(MyRoutePath configuration) async {
    // This is where we catch changes ???
    print("setNewRoutePath ${configuration.toString()}");
  }

}