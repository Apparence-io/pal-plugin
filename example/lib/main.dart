import 'package:flutter/material.dart';
import 'package:pal/pal.dart';
import 'router.dart';

void main() {
  runApp(MyApp());
}

const String APPLICATION_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTYxNjk4ZS05YWE0LTRkNTEtYjAyMS1hNjRkZDY3N2JiNTkiLCJ0eXBlIjoiUFJPSkVDVCIsImlhdCI6MTYwNTg4NTczMX0.CykI_pZUrVJhb6P2CWnqBkJT7erUBRkJbhsv0pYWvMw";

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
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
      // --- your app is here --
    );
  }

}
