import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/widgets/edit_helper_toolbar.dart';
import 'package:pal/src/ui/editor/widgets/editable_textfield.dart';

void main() {
  group('[EditableTextField] text', () {

    int changedTextCalledTimes;

    int changedStyleCalledTimes;

    OnFieldChanged onFieldChanged = (id, value) => changedTextCalledTimes++;

    OnTextStyleChanged onTextStyleChanged = (id, style, fontkeys) => changedStyleCalledTimes++;

    setUp(() async {
      changedTextCalledTimes = 0;
      changedStyleCalledTimes = 0;
    });

    testWidgets('change text calls onFieldChanged', (WidgetTester tester) async {
      var app = MaterialApp(
        home: PalTheme(
          theme: PalThemeData.light(),
          child: Material(
            child: EditableTextField.text(
              onChanged: onFieldChanged,
              onTextStyleChanged: onTextStyleChanged,
              toolbarVisibility: ValueNotifier(false),
              maxLines: 5,
            ),
          ))
      );
      await tester.pumpWidget(app);
      var titleField = find.byType(TextFormField);
      await tester.tap(titleField.first);
      await tester.pump();
      await tester.enterText(titleField, 'Hello');
      expect(changedTextCalledTimes, equals(1));
    });

    testWidgets('tap on field shows toolbar', (WidgetTester tester) async {
      var app = MaterialApp(
        home: PalTheme(
          theme: PalThemeData.light(),
          child: Material(
            child: EditableTextField.text(
              onChanged: onFieldChanged,
              onTextStyleChanged: onTextStyleChanged,
              toolbarVisibility: ValueNotifier(false),
              maxLines: 5,
            ),
          ))
      );
      await tester.pumpWidget(app);
      expect(find.byType(EditHelperToolbar), findsNothing);
      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      expect(find.byType(EditHelperToolbar), findsOneWidget);
    });

    testWidgets('maximumCharacterLength = 10, minimumCharacterLength = 2 '
      '=> validator("12") returns null, validator("longsentencemore") returns error ',
      (WidgetTester tester) async {
      var app = MaterialApp(
        home: PalTheme(
          theme: PalThemeData.light(),
          child: Material(
            child: EditableTextField.text(
              onChanged: onFieldChanged,
              onTextStyleChanged: onTextStyleChanged,
              toolbarVisibility: ValueNotifier(false),
              maxLines: 5,
              maximumCharacterLength: 10,
              minimumCharacterLength: 2,
            ),
          ))
      );
      await tester.pumpWidget(app);
      TextFormField textFormField = find.byType(TextFormField).evaluate().first.widget;
      expect(textFormField.validator("12345678910"), isNotNull);
      expect(textFormField.validator("12"), isNull);
    });

  });
}