import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/pages/create_helper/create_helper.dart';

GlobalKey<NavigatorState> palNavigatorGlobalKey = new GlobalKey<NavigatorState>();

void globalPop() {
  Navigator.pop(palNavigatorGlobalKey.currentContext);
  // return palNavigatorGlobalKey.currentState.pop();
}

Route<dynamic> route(RouteSettings settings) {
  switch (settings.name) {
    case '/editor/new':
      CreateHelperPageArguments args = settings.arguments;

      return MaterialPageRoute(
        builder: (context) => CreateHelperPage(
          pageId: args.pageId,
          hostedAppNavigatorKey: args.hostedAppNavigatorKey,
        ),
      );
    case '/editor/:id':
      return MaterialPageRoute(builder: (context) => Text('A route with id'));
    case '/editor/:id/edit':
      return MaterialPageRoute(
          builder: (context) => Text('A route with id with edit'));
    default:
      throw 'unexpected Route';
  }
}
