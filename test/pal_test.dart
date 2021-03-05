import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/pal.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/injectors/user_app/user_app_injector.dart';
import 'package:pal/src/ui/editor/widgets/bubble_overlay.dart';

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
        childApp: new MaterialApp(
          home: _myHomeTest,
          navigatorKey: _navigatorKey,
          navigatorObservers: [PalNavigatorObserver.instance()],
        ),
      );
      return app;
    }

    testWidgets('Create app with Pal in editor mode should inject EditorInjector', (WidgetTester tester) async {
      Pal app = _createApp(true);
      await tester.pumpWidget(app);
      var palFinder = find.byType(Pal).first;
      var editorInjectorFinder = find.byType(EditorInjector);
      var userAppInjectFinder = find.byType(UserInjector);

      expect(palFinder, findsOneWidget);
      expect(editorInjectorFinder, findsOneWidget);
      expect(userAppInjectFinder, findsNothing);
      // the bubble button should be available to turn on editor
      expect(find.byType(BubbleOverlayButton), findsOneWidget);
    });

    testWidgets('Create app with Pal in user mode should inject UserInjector', (WidgetTester tester) async {
      Pal app = _createApp(false);
      await tester.pumpWidget(app);
      var palFinder = find.byType(Pal).first;
      var editorAppContextFinder = find.byType(EditorInjector);
      expect(palFinder, findsOneWidget);
      expect(editorAppContextFinder, findsNothing);
      // expect(userAppContextFinder, findsOneWidget);
      // the bubble button should not be avaialble on this mode
      expect(find.byType(BubbleOverlayButton), findsNothing);
    });

  });
}

