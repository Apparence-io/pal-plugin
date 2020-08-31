import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_context.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/injectors/user_app/user_app_context.dart';
import 'package:palplugin/src/injectors/user_app/user_app_injector.dart';
import 'package:palplugin/src/ui/widgets/bubble_overlay.dart';

void main() {
  group('test main plugin start', () {

    final _navigatorKey = GlobalKey<NavigatorState>();

    Pal _createApp(bool editorModeEnabled) {
      Scaffold _myHomeTest = Scaffold(
        body: Container(),
      );
      Pal app = Pal(
        appToken: "testtoken",
        editorModeEnabled: editorModeEnabled,
        child: new MaterialApp(
          home: _myHomeTest,
          navigatorKey: _navigatorKey,
          navigatorObservers: [PalNavigatorObserver.instance()],
        ),
      );
      return app;
    }

    testWidgets('Create app with Pal in editor mode should inject EditorAppContext', (WidgetTester tester) async {
      Pal app = _createApp(true);
      await tester.pumpWidget(app);
      var palFinder = find.byType(Pal).first;
      var editorAppContextFinder = find.byType(EditorAppContext);
      var userAppContextFinder = find.byType(UserAppContext);

      expect(palFinder, findsOneWidget);
      expect(editorAppContextFinder, findsOneWidget);
      expect(userAppContextFinder, findsNothing);
      // the bubble button should be available to turn on editor
      expect(find.byType(BubbleOverlayButton), findsOneWidget);
    });

    testWidgets('Create app with Pal in user mode should inject UserInjector', (WidgetTester tester) async {
      Pal app = _createApp(false);
      await tester.pumpWidget(app);
      var palFinder = find.byType(Pal).first;
      var editorAppContextFinder = find.byType(EditorInjector);
      var userAppContextFinder = find.byType(UserInjector);
      expect(palFinder, findsOneWidget);
      expect(editorAppContextFinder, findsNothing);
      expect(userAppContextFinder, findsOneWidget);
      // the bubble button should not be avaialble on this mode
      expect(find.byType(BubbleOverlayButton), findsNothing);
    });

  });
}

