import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_action_bar/editor_action_bar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_save_floating_button.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/color_picker/color_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/dialog_editable_textfield.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor.dart';

main() {
  group('Editor Toolbox tests', () {
    ValueNotifier<EditableData> currentEditableItemNotifier =
        ValueNotifier(null);

    Future _beforeEach(WidgetTester tester) async {
      currentEditableItemNotifier = ValueNotifier(null);
      var app = MaterialApp(
        routes: {
          '/editor/media-gallery': (context) =>
              Scaffold(body: Text('Welcome to media gallery')),
        },
        home: PalTheme(
          theme: PalThemeData.light(),
          child: Material(
            child: EditorToolboxPage(
              key: ValueKey('EditorToolBarTest'),
              currentEditableItemNotifier: currentEditableItemNotifier,
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

    testWidgets('should loads properly', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.byType(EditorToolboxPage), findsOneWidget);
      expect(find.byType(EditorToolBar), findsOneWidget);
      expect(find.byType(EditorActionBar), findsOneWidget);
      expect(find.byType(EditorSaveFloatingButton), findsOneWidget);
    });

    testWidgets('should display or hide bottom bar on menu tap',
        (WidgetTester tester) async {
      await _beforeEach(tester);

      final menuButton = find.byKey(ValueKey('EditorToolBar_Menu'));
      await tester.tap(menuButton);
      await tester.pump(Duration(milliseconds: 1500));
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(EditorSaveFloatingButton), findsNothing);

      await tester.tap(menuButton);
      await tester.pump(Duration(milliseconds: 1500));
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(EditorSaveFloatingButton), findsOneWidget);
    });

    group('Specific actions', () {
      testWidgets('should open text picker on text button tap',
          (WidgetTester tester) async {
        await _beforeEach(tester);

        currentEditableItemNotifier.value = EditableTextFormData(
          1,
          'TEXT_KEY_EDITED',
          text: 'My Text',
          fontColor: Colors.yellow,
          fontSize: 20,
        );
        await tester.pumpAndSettle();

        final textButton =
            find.byKey(ValueKey('EditorToolBar_SpecificAction_Text'));
        await tester.tap(textButton);
        await tester.pumpAndSettle();

        expect(find.byType(EditableTextDialog), findsOneWidget);
        expect(
            find.byKey(ValueKey('EditableTextDialog_Field')), findsOneWidget);
      });

      testWidgets('should open font picker on font button tap',
          (WidgetTester tester) async {
        await _beforeEach(tester);

        currentEditableItemNotifier.value = EditableTextFormData(
          1,
          'TEXT_KEY_EDITED',
          text: 'My Text',
          fontColor: Colors.yellow,
          fontSize: 20,
          fontFamily: 'Montserrat',
          fontWeight: 'Medium',
        );
        await tester.pumpAndSettle();

        final fontButton =
            find.byKey(ValueKey('EditorToolBar_SpecificAction_Font'));
        await tester.tap(fontButton);
        await tester.pumpAndSettle();

        expect(find.byType(FontEditorDialogPage), findsOneWidget);
        expect(find.byKey(ValueKey('pal_FontEditorDialog')), findsOneWidget);
      });

      testWidgets('should open color picker on color button tap',
          (WidgetTester tester) async {
        await _beforeEach(tester);

        currentEditableItemNotifier.value = EditableTextFormData(
          1,
          'TEXT_KEY_EDITED',
          text: 'My Text',
          fontColor: Colors.yellow,
          fontSize: 20,
          fontFamily: 'Montserrat',
          fontWeight: 'Medium',
        );
        await tester.pumpAndSettle();

        final fontButton =
            find.byKey(ValueKey('EditorToolBar_SpecificAction_Color'));
        await tester.tap(fontButton);
        await tester.pumpAndSettle();

        expect(find.byType(ColorPickerDialog), findsOneWidget);
        expect(
            find.byKey(ValueKey('pal_ColorPickerAlertDialog')), findsOneWidget);
      });

      testWidgets('should open media picker on media button tap',
          (WidgetTester tester) async {
        await _beforeEach(tester);

        currentEditableItemNotifier.value = EditableMediaFormData(
            1, 'MEDIA_KEY_EDITED',
            url: 'http://myurl.png', uuid: '343HG2');
        await tester.pumpAndSettle();

        final fontButton =
            find.byKey(ValueKey('EditorToolBar_SpecificAction_Media'));
        await tester.tap(fontButton);
        await tester.pumpAndSettle();

        expect(find.text('Welcome to media gallery'), findsOneWidget);
      });
    });

    group('Global actions', () {
      testWidgets('should open color picker on global background button tap',
          (WidgetTester tester) async {
        await _beforeEach(tester);

        currentEditableItemNotifier.value = EditableTextFormData(
          1,
          'TEXT_KEY_EDITED',
          text: 'My Text',
          fontColor: Colors.yellow,
          fontSize: 20,
          fontFamily: 'Montserrat',
          fontWeight: 'Medium',
        );
        await tester.pumpAndSettle();

        final fontButton =
            find.byKey(ValueKey('EditorToolBar_GlobalAction_BackgroundColor'));
        await tester.tap(fontButton);
        await tester.pumpAndSettle();

        expect(find.byType(ColorPickerDialog), findsOneWidget);
        expect(
            find.byKey(ValueKey('pal_ColorPickerAlertDialog')), findsOneWidget);
      });
    });
  });
}
