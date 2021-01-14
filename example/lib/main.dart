import 'package:flutter/material.dart';
import 'package:pal/pal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';

void main() {
  runApp(MyApp());
}

const String APPLICATION_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4YTliMGM3OS1iNjEyLTQ2M2ItOWM1My0wM2Y5ZDk0YTQyODQiLCJ0eXBlIjoiUFJPSkVDVCIsImlhdCI6MTYxMDQ2NjIwMn0.qPKxSfngNWpSxwOmSzYft62wmuTIVX9eK550Lp3RHBo";

class MyApp extends StatelessWidget {

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Pal(
      editorModeEnabled: true,
      appToken: APPLICATION_TOKEN, // don't forget to give us a token (create it from the web dashboard configuration tab)
      // --- your app is here --
      childApp: MaterialApp(
        key: ValueKey('hostedApp'),
        initialRoute: '/',
        navigatorKey: _navigatorKey,
        navigatorObservers: [PalNavigatorObserver.instance()],
        title: 'Pal Demo',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: route,
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('fr')
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
      // --- your app is here --
    );
  }

}
