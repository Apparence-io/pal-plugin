import 'package:flutter/material.dart';
import 'package:pal_example/ui/pages/home/home_page.dart';
import 'package:pal_example/ui/pages/route1/route1_page.dart';
import 'package:pal_example/ui/pages/route2/route2_page.dart';

Route<dynamic> route(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => HomePage(),
        maintainState: true,
      );
    case '/route1':
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => Route1Page(),
      );
    case '/route2':
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => Route2Page(),
      );
    default:
      throw 'unexpected Route';
  }
}

