import 'package:flutter/material.dart';
import 'package:palplugin/palplugin.dart';

import 'router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Pal(
      navigatorKey: _navigatorKey,
      editorModeEnabled: true,
      child: MaterialApp(
        key: ValueKey('hostedApp'),
        initialRoute: '/',
        navigatorKey: _navigatorKey,
        title: 'Pal Demo',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (RouteSettings settings) => route(settings),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}