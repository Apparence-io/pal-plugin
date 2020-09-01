import 'package:flutter/material.dart';
import 'package:palplugin/palplugin.dart';

import 'router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  static PalNavigatorObserver _palNavigator = new PalNavigatorObserver();

  @override
  Widget build(BuildContext context) {
    return Pal(
      navigatorKey: _navigatorKey,
      editorModeEnabled: true,
      appToken:
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5YzgyMzlmOS1iMWVjLTQ3YTItYjg2Mi1mYTI3NGM0N2UwNmIiLCJ0eXBlIjoiUFJPSkVDVCIsImlhdCI6MTU5ODUyODk0OH0.4EAyk2jW4jkNlZbtosWzGDyY-U6INfO7XxoWX6PPU0c',
      child: MaterialApp(
        key: ValueKey('hostedApp'),
        initialRoute: '/',
        navigatorKey: _navigatorKey,
        navigatorObservers: [_palNavigator],
        title: 'Pal Demo',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: route,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
