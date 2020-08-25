import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/pages/editor/editor.dart';
import 'package:palplugin/src/ui/pages/editor/widgets/editor_button.dart';
import 'package:palplugin/src/ui/pages/editor/widgets/helpers_list.dart';


Future _initPage(EditorPageBuilder editorPageBuilder, WidgetTester tester) async {
  var app = new MediaQuery(
    data: MediaQueryData(),
    child: PalTheme(
      theme: PalThemeData.light(),
      child: Builder(
        builder: (context) => MaterialApp(
          theme: PalTheme.of(context).buildTheme(),
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: editorPageBuilder.build
          ),
        ),
      ),
    )
  );
  await tester.pumpWidget(app);
}

void main() {
  group('Editor', () {

    var editorPageBuilder = EditorPageBuilder();

    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _initPage(editorPageBuilder, tester);
      // page exists
      expect(find.byKey(ValueKey("EditorPage")), findsOneWidget);
      // has a add button to add helper box, validate and cancel
      var editButtonFinder = find.byType(EditorButton);
      expect(editButtonFinder, findsNWidgets(3));
    });

    testWidgets('click on add helper button should show helpers list options', (WidgetTester tester) async {
      await _initPage(editorPageBuilder, tester);
      var editButtonFinder = find.byKey(ValueKey("editModeButton"));
      // click on button
      await tester.tap(editButtonFinder);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      // shows options
      var helpersOptionsFinder = find.byType(HelpersListMenu);
      expect(helpersOptionsFinder, findsOneWidget);
      // check options
      expect(find.byKey(ValueKey("option")), findsNWidgets(2));
      expect(find.byKey(ValueKey("cancel")), findsOneWidget);
      expect(find.byKey(ValueKey("validate")), findsOneWidget);
    });

    testWidgets('Select an option make it highlithed with floating card explanation', (WidgetTester tester) async {
      await _initPage(editorPageBuilder, tester);
      var editButtonFinder = find.byKey(ValueKey("editModeButton"));
      // click on button
      await tester.tap(editButtonFinder);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      var option1 = find.byKey(ValueKey("option"));
      await tester.tap(option1.first);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
    });


  });
}

