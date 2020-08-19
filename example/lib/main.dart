import 'package:flutter/material.dart';
import 'package:pal_example/pages/home.dart';
import 'package:pal_example/pages/page1.dart';
import 'package:pal_example/pages/page2.dart';
import 'package:palplugin/palplugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Pal(
      navigatorKey: _navigatorKey,
      child: MaterialApp(
        initialRoute: '/',
        navigatorKey: _navigatorKey,
        title: 'Flutter Demo',
        // TODO: Export routes to a single file
        routes: {
          '/': (context) => MyHomePage(title: 'Pal test',),
          '/page1': (context) => Page1(),
          '/page2': (context) => Page2(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}