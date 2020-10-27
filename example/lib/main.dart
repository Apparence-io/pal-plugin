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
      editorModeEnabled: true,
      appToken: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0MWIxYTljNS1mODNjLTQ5OTMtYWRjOS0wOWY0Yzk0YWRmNjIiLCJ0eXBlIjoiUFJPSkVDVCIsImlhdCI6MTYwMjc2MjkyMH0.HDUIYt-gkrTGBww7lbydyhXB0Im8NeNVn36D4ZZWKYU',
      child: MaterialApp(
        key: ValueKey('hostedApp'),
        initialRoute: '/',
        navigatorKey: _navigatorKey,
        navigatorObservers: [PalNavigatorObserver.instance()],
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
