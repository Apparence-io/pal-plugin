import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';

class CreateHelperPresenterMock extends Mock implements CreateHelperPresenter {}

class CreateHelperModelMock extends Mock implements CreateHelperModel {}

var mockedPresenter = CreateHelperPresenterMock();
var mockedModel = CreateHelperModelMock();

Future _before(WidgetTester tester) async {
  when(mockedPresenter.checkValidStep()).thenAnswer((_) => Future.value([]));
  when(mockedModel.triggerTypes).thenReturn([
    HelperTriggerTypeDisplay(key: 'myKey', description: 'App launch'),
    HelperTriggerTypeDisplay(key: 'myKey2', description: 'On screen visit'),
    HelperTriggerTypeDisplay(key: 'myKey3', description: 'On app crash'),
  ]);
  when(mockedModel.helperNameController).thenReturn(TextEditingController());
  when(mockedModel.infosForm).thenReturn(GlobalKey<FormState>());
  when(mockedModel.infosForm).thenReturn(GlobalKey<FormState>());
  when(mockedModel.selectedTriggerType).thenReturn('myKey2');

  var app = MediaQuery(
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
      expect(find.byKey(ValueKey('palCreateHelperImage')), findsOneWidget);
      expect(
          find.byKey(ValueKey('palCreateHelperTextFieldName')), findsOneWidget);
      expect(
          find.byKey(ValueKey('palCreateHelperTypeDropdown')), findsOneWidget);
    });

    testWidgets('should insert helper name', (WidgetTester tester) async {
      await _before(tester);

      var helperName = find.byKey(ValueKey('palCreateHelperTextFieldName'));
      await tester.enterText(helperName, 'A Test');
      await tester.pumpAndSettle();

      expect(find.text('Please enter a name'), findsNothing);
    });

    testWidgets('textfield name should be disabled when no value',
        (WidgetTester tester) async {
      await _before(tester);

      var helperName = find.byKey(ValueKey('palCreateHelperTextFieldName'));
      await tester.enterText(helperName, '');
      await tester.pump();

      expect(find.text('Please enter a name'), findsOneWidget);
    });

    testWidgets('should change dropdown value', (WidgetTester tester) async {
      await _before(tester);

      final drop = find.byKey(ValueKey('palCreateHelperTypeDropdown'));
      await tester.tap(drop);
      await tester.pumpAndSettle();
      await tester.tap(find.text('App launch').last);
      await tester.pumpAndSettle();
      expect(find.text('App launch'), findsOneWidget);
    });
  });
}
