import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:pal/src/ui/editor/widgets/nested_navigator.dart';
import 'package:pal/src/ui/editor/widgets/progress_widget/progress_bar_widget.dart';

class _PackageVersionReaderMock extends Mock implements PackageVersionReader {}

final packageVersionReader = _PackageVersionReaderMock();

Future _before(WidgetTester tester) async {
  var app = MediaQuery(
    data: MediaQueryData(),
    child: PalTheme(
      theme: PalThemeData.light(),
      child: Builder(
        builder: (context) => MaterialApp(
          theme: PalTheme.of(context).buildTheme(),
          home: CreateHelperPage(
            packageVersionReader: packageVersionReader,
          ),
        ),
      ),
    ),
  );
  await tester.pumpWidget(app);

  when(packageVersionReader.init()).thenAnswer((realInvocation) => Future.value());
  when(packageVersionReader.appName).thenReturn('test');
  when(packageVersionReader.version).thenReturn('1.0.0');
}

void main() {
  group('Create helper page', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _before(tester);
      expect(find.text('Create new helper'), findsOneWidget);
      expect(find.byKey(ValueKey('palCreateHelperScrollList')), findsOneWidget);
      expect(
          find.byKey(ValueKey('pal_CreateHelper_TextField_Name')), findsOneWidget);
      expect(find.byKey(ValueKey('palCreateHelperNextButton')), findsOneWidget);
      expect(
          find.byKey(ValueKey('pal_CreateHelper_Dropdown_Type')), findsOneWidget);
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

      var helperName = find.byKey(ValueKey('pal_CreateHelper_TextField_Name'));
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

      var helperName = find.byKey(ValueKey('pal_CreateHelper_TextField_Name'));
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
