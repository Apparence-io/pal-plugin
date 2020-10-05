import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/widgets/alert_dialogs/font_size_picker.dart';

void main() {
  group('Color picker', () {
    FontSizePickerDialog fontSizePickerDialog = FontSizePickerDialog();

    _setup(WidgetTester tester) async {
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: PalTheme(
          theme: PalThemeData.light(),
          child: Builder(
            builder: (context) => MaterialApp(
              theme: PalTheme.of(context).buildTheme(),
              home: fontSizePickerDialog,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
    }

    testWidgets('should display correctly', (WidgetTester tester) async {
      await _setup(tester);

      expect(find.byKey(ValueKey('pal_FontSizePickerDialog')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontSizePickerDialog_PreviewText')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontSizePickerDialog_Slider')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontSizePickerDialog_CurrentValue')), findsOneWidget);

      expect(find.byKey(ValueKey('pal_FontSizePickerDialog_CancelButton')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontSizePickerDialog_ValidateButton')), findsOneWidget);

      expect(find.text('Change font size'), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Validate'), findsOneWidget);

    });

    testWidgets('should change font size by using slider', (WidgetTester tester) async {
      await _setup(tester);

      expect(find.text('20px'), findsOneWidget);

      var fontSizeSlider = find.byKey(ValueKey('pal_FontSizePickerDialog_Slider'));
      await tester.drag(fontSizeSlider, const Offset(15.0, 0.0));
      await tester.pumpAndSettle();

      expect(find.text('45px'), findsOneWidget);
    });
  });
}
