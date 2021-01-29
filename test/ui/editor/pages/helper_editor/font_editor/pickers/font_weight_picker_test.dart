import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker.dart';

void main() {
  group('Font weight picker', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _beforeEach(tester);

      // Check if page exist
      expect(find.byKey(ValueKey('pal_FontWeightPicker')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView')), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(9));

      expect(find.text('Font weight'), findsOneWidget);
    });

    testWidgets('should display font weight list', (WidgetTester tester) async {
      await _beforeEach(tester);

      // Check if page exist
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile0')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile1')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile2')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile3')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile4')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile5')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile6')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile7')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile8')), findsOneWidget);

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontWeightPicker_ListView_ListTile_Check0')), findsOneWidget);

      expect(find.text('Font weight'), findsOneWidget);
    });
  });
}

Future _beforeEach(
  WidgetTester tester,
) async {
  final component = FontWeightPickerPage(
    arguments: FontWeightPickerArguments(
      fontFamilyName: 'Roboto',
      fontWeightName: 'Thin',
    ),
  );
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(),
      child: PalTheme(
        theme: PalThemeData.light(),
        child: Builder(
          builder: (context) => MaterialApp(
            theme: PalTheme.of(context).buildTheme(),
            home: component,
          ),
        ),
      ),
    ),
  );
}