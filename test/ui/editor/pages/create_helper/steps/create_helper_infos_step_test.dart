import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';

class _CreateHelperPresenterMock extends Mock implements CreateHelperPresenter {
}

class _CreateHelperModelMock extends Mock implements CreateHelperModel {}

class _PackageVersionReaderMock extends Mock implements PackageVersionReader {}

var packageReader = _PackageVersionReaderMock();
var mockedPresenter = _CreateHelperPresenterMock();
var mockedModel = _CreateHelperModelMock();

Future _before(WidgetTester tester) async {
  when(mockedPresenter.checkValidStep()).thenAnswer((_) => Future.value([]));
  when(mockedModel.triggerTypes).thenReturn([
    HelperTriggerTypeDisplay(key: 'myKey', description: 'App launch'),
    HelperTriggerTypeDisplay(key: 'myKey2', description: 'On screen visit'),
    HelperTriggerTypeDisplay(key: 'myKey3', description: 'On app crash'),
  ]);
  when(mockedModel.helperNameController).thenReturn(TextEditingController());
  when(mockedModel.minVersionController).thenReturn(TextEditingController());
  when(mockedModel.isAppVersionLoading).thenReturn(false);
  when(mockedModel.infosForm).thenReturn(GlobalKey<FormState>());
  when(mockedModel.selectedTriggerType).thenReturn('myKey2');
  when(mockedModel.appVersion).thenReturn('1.0.0');
  when(mockedPresenter.readAppVersion())
      .thenAnswer((realInvocation) => Future.value());

  final app = MediaQuery(
    data: MediaQueryData(),
    child: PalTheme(
      theme: PalThemeData.light(),
      child: Builder(
        builder: (context) => MaterialApp(
          theme: PalTheme.of(context).buildTheme(),
          home: Material(
            child: CreateHelperInfosStep(
              presenter: mockedPresenter,
              model: mockedModel,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpWidget(app);
}

void main() {
  group('[Step 1] Create helper page infos', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _before(tester);

      expect(find.byKey(ValueKey('palCreateHelperScrollList')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_CreateHelper_TextField_Name')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_CreateHelper_Dropdown_Type')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_CreateHelper_TextField_MinimumVersion')),
          findsOneWidget);
    });

    testWidgets('should insert helper name', (WidgetTester tester) async {
      await _before(tester);

      var helperName = find.byKey(ValueKey('pal_CreateHelper_TextField_Name'));
      await tester.enterText(helperName, 'A Test');
      await tester.pumpAndSettle();

      expect(find.text('Please enter a name'), findsNothing);
    });

    testWidgets('textfield name should be disabled when no value',
        (WidgetTester tester) async {
      await _before(tester);

      var helperName = find.byKey(ValueKey('pal_CreateHelper_TextField_Name'));
      await tester.enterText(helperName, 'First typing');
      await tester.pumpAndSettle();

      expect(find.text('Please enter a name'), findsNothing);

      await tester.enterText(helperName, '');
      await tester.pumpAndSettle();

      expect(find.text('Please enter a name'), findsOneWidget);
    });

    testWidgets('should change dropdown value', (WidgetTester tester) async {
      await _before(tester);

      final drop = find.byKey(ValueKey('pal_CreateHelper_Dropdown_Type'));
      await tester.tap(drop);
      await tester.pumpAndSettle();
      await tester.tap(find.text('App launch').last);
      await tester.pumpAndSettle();
      expect(find.text('App launch'), findsOneWidget);
    });

    testWidgets('should insert minimum helper version', (WidgetTester tester) async {
      await _before(tester);

      var helperName = find.byKey(ValueKey('pal_CreateHelper_TextField_MinimumVersion'));
      await tester.enterText(helperName, '1.0.2');
      await tester.pumpAndSettle();

      expect(find.text('Please enter a version'), findsNothing);
      expect(find.text('Please enter a valid version'), findsNothing);
    });

    testWidgets('should disable form when invalid version was entered', (WidgetTester tester) async {
      await _before(tester);

      var helperName = find.byKey(ValueKey('pal_CreateHelper_TextField_MinimumVersion'));
      await tester.enterText(helperName, '01.002dfs.sqf009');
      await tester.pumpAndSettle();

      expect(find.text('Please enter a version'), findsNothing);
      expect(find.text('Please enter a valid version'), findsOneWidget);
    });

    testWidgets('should display to enter version when no one exist', (WidgetTester tester) async {
      await _before(tester);

      var helperName = find.byKey(ValueKey('pal_CreateHelper_TextField_MinimumVersion'));
      await tester.enterText(helperName, 'First version');
      await tester.pumpAndSettle();

      await tester.enterText(helperName, '');
      await tester.pumpAndSettle();

      expect(find.text('Please enter a version'), findsOneWidget);
      expect(find.text('Please enter a valid version'), findsNothing);
    });
  });
}
