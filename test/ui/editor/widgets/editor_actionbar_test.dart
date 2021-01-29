import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/theme.dart';

main() {
  group('Editor Actionbar tests', () {
    var editorState;

    Future _beforeEach(WidgetTester tester) async {
      var app = MaterialApp(
        home: PalTheme(
          theme: PalThemeData.light(),
          child: Material(
            child: EditorActionsBar(
              key: ValueKey('EditorActionBarTest'),
              child: Container(),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pump();

      editorState = tester.state(find.byType(EditorActionsBar));
    }

    testWidgets('Loads properly', (WidgetTester tester) async {
      await _beforeEach(tester);
      expect(find.byKey(ValueKey('EditorActionBarTest')), findsOneWidget);
    });

    testWidgets('Opens and closes properly', (WidgetTester tester) async {
      await _beforeEach(tester);
      Finder openCloseButton =
          find.byKey(ValueKey('EditorActionBarDrawerButton'));

      expect(openCloseButton, findsOneWidget);
      expect(editorState.controller.value, equals(0));

      await tester.tap(openCloseButton);
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(editorState.controller.value, equals(1));
    });
  });
}
