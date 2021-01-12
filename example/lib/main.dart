import 'package:flutter/material.dart';
import 'package:pal/pal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';

void main() {
  runApp(MyApp());
}

const String APPLICATION_TOKEN = "APP_TOKEN";

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
