import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_context.dart';
import 'package:palplugin/src/injectors/user_app/user_app_context.dart';

void main() {
  group('test main plugin start', () {

    testWidgets('Create app with Pal in editor mode should inject EditorAppContext', (WidgetTester tester) async {
      Scaffold _myHomeTest = Scaffold(
        body: Container(),
      );
      Pal app = Pal(
        child: new MaterialApp(
          home: _myHomeTest,
        ),
        editorModeEnabled: true,
      );
      await tester.pumpWidget(app);
      var palFinder = find.byType(Pal).first;
      var editorAppContextFinder = find.byType(EditorAppContext);
      var userAppContextFinder = find.byType(UserAppContext);
      expect(palFinder, findsOneWidget);
      expect(editorAppContextFinder, findsOneWidget);
      expect(userAppContextFinder, findsNothing);
    });

    testWidgets('Create app with Pal in user mode should inject UserAppContext', (WidgetTester tester) async {
      Scaffold _myHomeTest = Scaffold(
        body: Container(),
      );
      Pal app = Pal(
        child: new MaterialApp(
          home: _myHomeTest,
        ),
        editorModeEnabled: false,
      );
      await tester.pumpWidget(app);
      var palFinder = find.byType(Pal).first;
      var editorAppContextFinder = find.byType(EditorAppContext);
      var userAppContextFinder = find.byType(UserAppContext);
      expect(palFinder, findsOneWidget);
      expect(editorAppContextFinder, findsNothing);
      expect(userAppContextFinder, findsOneWidget);
    });

  });
}