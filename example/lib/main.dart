import 'package:flutter/material.dart';
import 'package:pal_example/router.dart';
import 'package:palplugin/palplugin.dart';

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
      appToken:
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkYzExNzFlNS0xYTc2LTRmYjUtOWM3Yi0yZWM4ZjcxMWQ1ZDUiLCJ0eXBlIjoiUFJPSkVDVCIsImlhdCI6MTU5NzkyODcxMH0.cJ8qEQj_3aL9scDX3Q96xZ-P6LdZE2IJZddovmp7dJU',
      child: MaterialApp(
        key: ValueKey('hostedApp'),
        initialRoute: '/',
        navigatorKey: _navigatorKey,
        navigatorObservers: [_palNavigator],
        title: 'Pal Demo',
        onGenerateRoute: (RouteSettings settings) => route(settings),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
