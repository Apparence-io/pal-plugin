import 'package:flutter/material.dart';
import 'package:pal/pal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';

void main() {
  runApp(MyApp());
}

const String APPLICATION_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4NzYwOTU3Ni0wYTNjLTQzMTMtODJhYi0zMjQ5YTAyODE4YTIiLCJ0eXBlIjoiUFJPSkVDVCIsImlhdCI6MTYxMjk1MzMxNH0.JU45a2cl06i3pSHY1zlPIL5fHvbZ-vPt7x_fciObxQk";

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
