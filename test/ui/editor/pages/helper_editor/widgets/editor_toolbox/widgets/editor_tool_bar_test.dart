import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';

main() {
  group('Editor ToolBar tests', () {
    ValueNotifier<EditableData> currentEditableItemNotifier =
        ValueNotifier(null);

    Future _beforeEach(WidgetTester tester) async {
      currentEditableItemNotifier = ValueNotifier(null);
      var app = MaterialApp(
        home: PalTheme(
          theme: PalThemeData.light(),
          child: Material(
            child: EditorToolboxPage(
              key: ValueKey('EditorToolBarTest'),
              currentEditableItemNotifier: currentEditableItemNotifier,
              isToolsVisible: true,
              boxViewHandler: BoxViewHandler(
                  selectedColor: Colors.red, callback: (test) {}),
              child: Scaffold(
                body: Text('Hello child!'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
    }

    testWidgets('should display all element for text item',
        (WidgetTester tester) async {
      await _beforeEach(tester);

      currentEditableItemNotifier.value = EditableTextFormData(
        1,
        'TEXT_KEY_EDITED',
        text: 'My Text',
        fontColor: Colors.yellow,
        fontSize: 20,
      );
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Border')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Media')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_More')),
          findsNothing);

      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Color')),
          findsOneWidget);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Font')),
          findsOneWidget);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Text')),
          findsOneWidget);
    });

    testWidgets('should display all element for media item',
        (WidgetTester tester) async {
      await _beforeEach(tester);

      currentEditableItemNotifier.value = EditableMediaFormData(
        1,
        'BUTTON_KEY',
        url: 'http://test.png',
        uuid: 'TestId',
      );
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Border')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_More')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Color')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Font')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Text')),
          findsNothing);

      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Media')),
          findsOneWidget);
    });

    testWidgets('should loads properly', (WidgetTester tester) async {
      await _beforeEach(tester);
      expect(find.byType(EditorToolboxPage), findsOneWidget);
      expect(find.byType(EditorToolBar), findsOneWidget);

      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Border')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Color')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Font')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Media')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_Text')),
          findsNothing);
      expect(find.byKey(ValueKey('EditorToolBar_SpecificAction_More')),
          findsNothing);

      expect(find.byKey(ValueKey('EditorToolBar_GlobalAction_BackgroundColor')),
          findsOneWidget);
      expect(find.byKey(ValueKey('EditorToolBar_GlobalAction_More')),
          findsNothing);
    });

    testWidgets('should display all global actions',
        (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.byKey(ValueKey('EditorToolBar_GlobalAction_BackgroundColor')),
          findsOneWidget);
      expect(find.byKey(ValueKey('EditorToolBar_GlobalAction_More')),
          findsNothing);
    });
  });
}
