import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';

void main() {
  group('Color picker', () {
    ColorPickerDialog colorPickerDialog = ColorPickerDialog();

    _setup(WidgetTester tester) async {
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: PalTheme(
          theme: PalThemeData.light(),
          child: Builder(
            builder: (context) => MaterialApp(
              theme: PalTheme.of(context).buildTheme(),
              home: colorPickerDialog,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
    }

    testWidgets('should display correctly', (WidgetTester tester) async {
      await _setup(tester);

      expect(find.byKey(ValueKey('pal_ColorPickerAlertDialog')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_ColorPickerAlertDialog_CancelButton')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton')), findsOneWidget);

      expect(find.text('Pick a color'), findsOneWidget);

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Validate'), findsOneWidget);

      expect(find.text('Please enter valid color'), findsOneWidget);
    });

    testWidgets('should change color by entering new hex value', (WidgetTester tester) async {
      await _setup(tester);
      var hexColorTextField;

      hexColorTextField = find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
      await tester.enterText(hexColorTextField, '#FF4567F5');
      await tester.pumpAndSettle();
      expect(find.text('Please enter valid color'), findsNothing);
      expect(tester.widget<FlatButton>(find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'))).enabled, isTrue);

      hexColorTextField = find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
      await tester.enterText(hexColorTextField, 'dskkqs8gd');
      await tester.pumpAndSettle();
      expect(find.text('Please enter valid color'), findsOneWidget);
      expect(tester.widget<FlatButton>(find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'))).enabled, isFalse);

      hexColorTextField = find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
      await tester.enterText(hexColorTextField, '42F56055');
      await tester.pumpAndSettle();
      expect(find.text('Please enter valid color'), findsNothing);
      expect(tester.widget<FlatButton>(find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'))).enabled, isTrue);

      hexColorTextField = find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
      await tester.enterText(hexColorTextField, '#FFFFFFFF');
      await tester.pumpAndSettle();
      expect(find.text('Please enter valid color'), findsNothing);
      expect(tester.widget<FlatButton>(find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'))).enabled, isTrue);
    });
  });
}
