import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/pages/create_helper/create_helper.dart';

GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();


Route<dynamic> route(RouteSettings settings) {
  switch (settings.name) {
    case '/editor/new':
      return MaterialPageRoute(builder: (context) => CreateHelperPage());
    case '/editor/:id':
      return MaterialPageRoute(builder: (context) => Text('A route with id'));
    case '/editor/:id/edit':
      return MaterialPageRoute(builder: (context) => Text('A route with id with edit'));
    default:
      throw 'unexpected Route';
  }
}