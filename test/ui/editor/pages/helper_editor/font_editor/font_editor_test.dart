import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_size_picker.dart';

void main() {
  group('Font editor dialog', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.byKey(ValueKey('pal_FontEditorDialog')), findsOneWidget);
      expect(
          find.byKey(ValueKey('pal_FontEditorDialog_Preview')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontEditorDialog_List')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontEditorDialog_List_FontFamily')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontEditorDialog_List_FontWeight')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontEditorDialog_CancelButton')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontEditorDialog_ValidateButton')),
          findsOneWidget);
      expect(find.byType(FontSizePicker), findsOneWidget);
    });

    testWidgets('should change font size', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.text('20px'), findsOneWidget);

      var fontSizeSlider =
          find.byKey(ValueKey('pal_FontSizePicker_Slider'));
      await tester.drag(fontSizeSlider, const Offset(15.0, 0.0));
      await tester.pumpAndSettle();

      expect(find.text('45px'), findsOneWidget);
    });

    testWidgets('should open font family picker', (WidgetTester tester) async {
      await _beforeEach(tester);

      var fontFamilyButton =
          find.byKey(ValueKey('pal_FontEditorDialog_List_FontFamily'));
      await tester.tap(fontFamilyButton);
      await tester.pumpAndSettle();

      expect(find.text('Font family picker'), findsOneWidget);
    });

    testWidgets('should open font family picker', (WidgetTester tester) async {
      await _beforeEach(tester);

      var fontFamilyButton =
          find.byKey(ValueKey('pal_FontEditorDialog_List_FontWeight'));
      await tester.tap(fontFamilyButton);
      await tester.pumpAndSettle();

      expect(find.text('Font weight picker'), findsOneWidget);
    });
  });
}

Future _beforeEach(
  WidgetTester tester,
) async {
  final component = FontEditorDialogPage();
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(),
      child: PalTheme(
        theme: PalThemeData.light(),
        child: Builder(
          builder: (context) => MaterialApp(
            theme: PalTheme.of(context).buildTheme(),
            home: component,
            routes: {
              '/editor/new/font-family': (context) => Scaffold(
                    body: Text('Font family picker'),
                  ),
              '/editor/new/font-weight': (context) => Scaffold(
                    body: Text('Font weight picker'),
                  ),
            },
          ),
        ),
      ),
    ),
  );
}
