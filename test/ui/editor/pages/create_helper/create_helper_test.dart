import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:palplugin/src/ui/editor/widgets/nested_navigator.dart';
import 'package:palplugin/src/ui/editor/widgets/progress_widget/progress_bar_widget.dart';

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
      expect(
          find.byKey(ValueKey('palCreateHelperTypeDropdown')), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.byType(NestedNavigator), findsOneWidget);
      expect(find.byType(ProgressBarWidget), findsOneWidget);
    });

    testWidgets('should next button be active', (WidgetTester tester) async {
      await _before(tester);

      expect(
          tester
              .widget<RaisedButton>(
                  find.byKey(ValueKey('palCreateHelperNextButton')))
              .enabled,
          isFalse);

      var helperName = find.byKey(ValueKey('palCreateHelperTextFieldName'));
      await tester.enterText(helperName, 'My awesome helper');
      await tester.pump();

      expect(
          tester
              .widget<RaisedButton>(
                  find.byKey(ValueKey('palCreateHelperNextButton')))
              .enabled,
          isTrue);
    });

    testWidgets('should next button be disabled', (WidgetTester tester) async {
      await _before(tester);

      var helperName = find.byKey(ValueKey('palCreateHelperTextFieldName'));
      await tester.enterText(helperName, '');
      await tester.pump();

      expect(
          tester
              .widget<RaisedButton>(
                  find.byKey(ValueKey('palCreateHelperNextButton')))
              .enabled,
          isFalse);
    });
  });
}
