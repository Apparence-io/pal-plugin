import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper_widget.dart';
import 'package:palplugin/src/ui/pages/editor/editor.dart';
import 'package:palplugin/src/ui/pages/editor/editor_loader.dart';
import 'package:palplugin/src/ui/pages/editor/widgets/editor_button.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal.dart';
import 'package:palplugin/src/ui/editor/widgets/modal_bottomsheet_options.dart';

class EditorLoaderMock extends Mock implements EditorLoader {}

Future _initPage(
  WidgetTester tester,
) async {
  EditorLoader loader = EditorLoaderMock();
  var app = new MediaQuery(
      data: MediaQueryData(),
      child: PalTheme(
        theme: PalThemeData.light(),
        child: Builder(
          builder: (context) => MaterialApp(
            theme: PalTheme.of(context).buildTheme(),
            onGenerateRoute: (_) => MaterialPageRoute(
                builder: EditorPageBuilder(
              '',
              null,
              loader: loader,
            ).build),
          ),
        ),
      ));
  await tester.pumpWidget(app);
}

void main() {
  group('Editor', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _initPage(tester);
      // page exists
      expect(find.byKey(ValueKey("EditorPage")), findsOneWidget);
      // has a add button to add helper box, validate and cancel
      var editButtonFinder = find.byType(EditorButton);
      expect(editButtonFinder, findsNWidgets(3));
    });

    testWidgets('click on add helper button should show helpers list options',
        (WidgetTester tester) async {
      await _initPage(tester);
      var editButtonFinder = find.byKey(ValueKey("editModeButton"));
      // click on button
      await tester.tap(editButtonFinder);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      // shows options
      var helpersOptionsFinder = find.byType(ModalBottomSheetOptions);
      expect(helpersOptionsFinder, findsOneWidget);
      // check options
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.byKey(ValueKey("cancel")), findsOneWidget);
      expect(find.byKey(ValueKey("validate")), findsOneWidget);
    });

    testWidgets(
        'Select an option make it highlithed with floating card explanation',
        (WidgetTester tester) async {
      await _initPage(tester);
      var editButtonFinder = find.byKey(ValueKey("editModeButton"));
      // click on button
      await tester.tap(editButtonFinder);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      var option1 = find.byKey(ValueKey("option0"));
      await tester.tap(option1.first);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
    });

    group('fullscreen helper', () {
      _addFullScreenWidget(WidgetTester tester) async {
        var editButtonFinder = find.byKey(ValueKey("editModeButton"));
        // click on button
        await tester.tap(editButtonFinder);
        await tester.pump();
        await tester.pumpAndSettle(Duration(milliseconds: 500));
        var option2 = find.byKey(ValueKey("option1"));
        await tester.tap(option2.first);
        await tester.pump();
        await tester.pumpAndSettle(Duration(milliseconds: 500));
        var validateButton = find.byKey(ValueKey("validate"));
        await tester.tap(validateButton.first);
        await tester.pumpAndSettle(Duration(milliseconds: 1000));
      }

      testWidgets('can add a fullscreen helper', (WidgetTester tester) async {
        await _initPage(tester);
        await _addFullScreenWidget(tester);
        expect(find.byType(ModalBottomSheetOptions), findsNothing);
        expect(find.byType(FullscreenHelperWidget), findsOneWidget);
      });

      testWidgets('can edit fullscreen title', (WidgetTester tester) async {
        await _initPage(tester);
        await _addFullScreenWidget(tester);
        expect(find.text('Edit me!'), findsOneWidget);
        var titleField = find.byKey(ValueKey('palFullscreenHelperTitleField'));
        await tester.tap(titleField.first);
        await tester.pump();
        await tester.enterText(titleField, 'Bonjour!');
        expect(find.text('Bonjour!'), findsOneWidget);
      });

      testWidgets('can save helper', (WidgetTester tester) async {
        await _initPage(tester);
        await _addFullScreenWidget(tester);
        expect(find.text('Edit me!'), findsOneWidget);
        var titleField = find.byKey(ValueKey('palFullscreenHelperTitleField'));
        await tester.tap(titleField.first);
        await tester.pump();
        await tester.enterText(titleField, 'Bonjour!');
        expect(find.text('Bonjour!'), findsOneWidget);

        // TODO: Add validate button tap
      });
    });
  });
}
