import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step.dart';

class _CreateHelperPresenterMock extends Mock implements CreateHelperPresenter {
}

class _CreateHelperModelMock extends Mock implements CreateHelperModel {}

class _PackageVersionReaderMock extends Mock implements PackageVersionReader {}

var packageReader = _PackageVersionReaderMock();
var mockedPresenter = _CreateHelperPresenterMock();
var mockedModel = _CreateHelperModelMock();

Future _before(WidgetTester tester) async {
  when(mockedPresenter.checkValidStep()).thenAnswer((_) => Future.value([]));
  when(mockedModel.helperNameController).thenReturn(TextEditingController());
  when(mockedModel.isAppVersionLoading).thenReturn(false);
  when(mockedModel.infosForm).thenReturn(GlobalKey<FormState>());
  when(mockedModel.appVersion).thenReturn('1.0.0');
  when(mockedModel.isFormValid).thenReturn(ValueNotifier(false));
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
      expect(find.byKey(ValueKey('pal_CreateHelper_TextField_Name')), findsOneWidget);
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

  });
}
