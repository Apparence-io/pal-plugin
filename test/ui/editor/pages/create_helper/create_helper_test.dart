import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper.dart';

Future _before(WidgetTester tester) async {
  var app = MediaQuery(
    data: MediaQueryData(),
    child: PalTheme(
      theme: PalThemeData.light(),
      child: Builder(
        builder: (context) => MaterialApp(
          theme: PalTheme.of(context).buildTheme(),
          home: CreateHelperPage(),
        ),
      ),
    ),
  );
  await tester.pumpWidget(app);
}

void main() {
  group('Create helper page', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _before(tester);
      expect(find.byKey(ValueKey('CreateHelper')), findsOneWidget);
      expect(find.text('Create new helper'), findsOneWidget);
      expect(find.byKey(ValueKey('palCreateHelperScrollList')), findsOneWidget);
      expect(find.byKey(ValueKey('palCreateHelperImage')), findsOneWidget);
      expect(
          find.byKey(ValueKey('palCreateHelperTextFieldName')), findsOneWidget);
      expect(find.byKey(ValueKey('palCreateHelperNextButton')), findsOneWidget);
      expect(find.byKey(ValueKey('palCreateHelperTypeDropdown')), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should insert helper name', (WidgetTester tester) async {
      await _before(tester);

      expect(
          tester
              .widget<RaisedButton>(
                  find.byKey(ValueKey('palCreateHelperNextButton')))
              .enabled,
          isFalse);

      var helperName = find.byKey(ValueKey('palCreateHelperTextFieldName'));
      await tester.enterText(helperName, 'My awesome helper');
      await tester.pumpAndSettle();

      expect(
          tester
              .widget<RaisedButton>(
                  find.byKey(ValueKey('palCreateHelperNextButton')))
              .enabled,
          isTrue);
    });

    testWidgets('textfield name should be disabled when no value', (WidgetTester tester) async {
      await _before(tester);

      var helperName = find.byKey(ValueKey('palCreateHelperTextFieldName'));
      await tester.enterText(helperName, '');
      await tester.pumpAndSettle();

      expect(
          tester
              .widget<RaisedButton>(
                  find.byKey(ValueKey('palCreateHelperNextButton')))
              .enabled,
          isFalse);
    });

    testWidgets('should select on screen visit type', (WidgetTester tester) async {
      await _before(tester);

      var dropdownHelperType = find.byKey(ValueKey('palCreateHelperTypeDropdown'));
      await tester.tap(dropdownHelperType);
      await tester.pumpAndSettle();

      // TODO: Can only be done when more type are added
    });
  });
}
