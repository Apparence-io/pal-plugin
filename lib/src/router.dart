import 'package:flutter/material.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/ui/pages/editor/editor.dart';

GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();

var editorPageBuilder = EditorPageBuilder();

Route<dynamic> route(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Pal(navigatorKey: key, child: null,), maintainState: true);
    case '/editor/new':
      return MaterialPageRoute(builder: (context) => Scaffold(body: Text('New')));
    case '/editor':
      return MaterialPageRoute(builder: editorPageBuilder.build);
    case '/editor/:id/edit':
      return MaterialPageRoute(builder: (context) => Scaffold(body: Text('New')));
    default:
      throw 'unexpected Route';
  }
}