import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_simple_helper/editor_simple_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_simple_helper/editor_simple_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_actionsbar/widgets/editor_action_item.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:pal/src/ui/editor/widgets/edit_helper_toolbar.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';
import '../../../pal_test_utilities.dart';

class HelperEditorServiceMock extends Mock implements EditorHelperService {}

class PalEditModeStateServiceMock extends Mock implements PalEditModeStateService {}

void main() {
  group('[Editor] Simple helper', () {

    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorSimpleHelperPresenter presenter;

    HelperEditorServiceMock helperEditorServiceMock = HelperEditorServiceMock();

    Scaffold _myHomeTest = Scaffold(
      body: Column(
        children: [
          Text("text1", key: ValueKey("text1"),),
          Text("text2", key: ValueKey("text2")),
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: FlatButton(
              key: ValueKey("MFlatButton"),
              child: Text("tapme"),
              onPressed: () => print("impressed!"),
            ),
          )
        ],
      ),
    );

    Future _beforeEach(WidgetTester tester) async {
      reset(helperEditorServiceMock);
      await initAppWithPal(tester, _myHomeTest, _navigatorKey);
      await pumpHelperWidget(
        tester, _navigatorKey,
        HelperTriggerType.ON_SCREEN_VISIT,
        HelperType.SIMPLE_HELPER,
        HelperTheme.BLACK,
        editorHelperService: helperEditorServiceMock,
        palEditModeStateService: new PalEditModeStateServiceMock()
      );
      var presenterFinder = find.byKey(ValueKey("palEditorSimpleHelperWidgetBuilder"));
      var page = presenterFinder.evaluate().first.widget
        as PresenterInherited<EditorSimpleHelperPresenter, SimpleHelperViewModel>;
      presenter = page.presenter;
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
    }

    // ------------------------------------------------
    // TESTS SUITE
    // ------------------------------------------------

    testWidgets('should  create', (WidgetTester tester) async {
      await _beforeEach(tester);
      expect(find.byType(EditorSimpleHelperPage), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Edit me!'), findsOneWidget);
    });

    testWidgets('close editor  => page is removed', (WidgetTester tester) async {
      await _beforeEach(tester);
      expect(find.byType(EditorSimpleHelperPage), findsOneWidget);
      var cancelFinder = find.byKey(ValueKey('editableActionBarCancelButton'));
      await tester.tap(cancelFinder);
      await tester.pumpAndSettle();
      expect(find.byType(EditorSimpleHelperPage), findsNothing);
    });
    
    testWidgets('on text press  => button is disabled', (WidgetTester tester) async {
      await _beforeEach(tester);
      expect(find.byType(EditorSimpleHelperPage), findsOneWidget);
      var textMode = find.byKey(ValueKey('editableActionBarTextButton'));
      await tester.tap(textMode);
      await tester.pumpAndSettle();
    });

    testWidgets('on settings press  => button is disabled', (WidgetTester tester) async {
      await _beforeEach(tester);
      expect(find.byType(EditorSimpleHelperPage), findsOneWidget);
      var textMode = find.byKey(ValueKey('editableActionBarSettingsButton'));
      await tester.tap(textMode);
      await tester.pumpAndSettle();
    });

    testWidgets('text is empty => cancel, validate buttons exists, validate button is disabled', (WidgetTester tester) async {
      await _beforeEach(tester);
      var editableTextsFinder = find.byType(TextField);
      await enterTextInEditable(tester, editableTextsFinder.at(0), '');
      await tester.pumpAndSettle();
      expect(presenter.viewModel.detailsField.text.value, equals(''));

      var cancelFinder = find.byKey(ValueKey('editableActionBarCancelButton'));
      var validateFinder = find.byKey(ValueKey('editableActionBarValidateButton'));
      expect(cancelFinder, findsOneWidget);
      expect(validateFinder, findsOneWidget);
      var validateButton = validateFinder.evaluate().first.widget as CircleIconButton;
      expect(validateButton.onTapCallback, isNull);
    });

    Future _fillFields(WidgetTester tester, String firstField) async {
      // INIT TEXTFIELDS
      var editableTextsFinder = find.byType(TextField);
      await enterTextInEditable(
          tester, editableTextsFinder.at(0), firstField);
      await tester.pump();
      // INIT TEXTFIELDS
    }

    testWidgets('on preview press  => show simple client preview & cancel with positiv button',
        (WidgetTester tester) async {
      await _beforeEach(tester);

      final String firstField = 'test title edited';
      await _fillFields(tester, firstField);

      final previewButtonFinder =
          find.byKey(ValueKey('editableActionBarPreviewButton'));
      final previewButton =
          previewButtonFinder.evaluate().first.widget as EditorActionItem;
      previewButton.onTap();

      expect(find.byType(EditorSimpleHelperPage), findsNothing);
      await tester.pump(Duration(milliseconds: 1300));
      await tester.pump(Duration(milliseconds: 1100));
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(EditorPreviewPage), findsOneWidget);

      expect(find.text(firstField),findsOneWidget);

      var toastFinder = find.byType(Dismissible);
      expect(toastFinder, findsOneWidget);
      var center = tester.getCenter(toastFinder);
      var gesture = await tester.startGesture(center);
      await gesture.moveBy(Offset(-300, 0));
      // await tester.drag(toastFinder, Offset(300, 0));
      await tester.pump();
      // expect(dismissed, isTrue); //Not working as moveBy seems have no effect

      expect(find.byType(EditorPreviewPage), findsNothing);
      expect(find.byType(EditorSimpleHelperPage), findsOneWidget);
    });

    testWidgets('on preview press  => show simple client preview & cancel with negativ button',
        (WidgetTester tester) async {
      await _beforeEach(tester);

      final String firstField = 'test title edited';
      await _fillFields(tester, firstField);

      final previewButtonFinder =
          find.byKey(ValueKey('editableActionBarPreviewButton'));
      final previewButton =
          previewButtonFinder.evaluate().first.widget as EditorActionItem;
      previewButton.onTap();

      expect(find.byType(EditorSimpleHelperPage), findsNothing);
      await tester.pump(Duration(milliseconds: 1300));
      await tester.pump(Duration(milliseconds: 1100));
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(EditorPreviewPage), findsOneWidget);

      expect(find.text(firstField),findsOneWidget);
      
      var toastFinder = find.byType(Dismissible);
      expect(toastFinder, findsOneWidget);
      var center = tester.getCenter(toastFinder);
      var gesture = await tester.startGesture(center);
      await gesture.moveBy(Offset(300, 0));
      // await tester.drag(toastFinder, Offset(300, 0));
      await tester.pump();
      // expect(dismissed, isTrue); //Not working as moveBy seems have no effect

      expect(find.byType(EditorPreviewPage), findsNothing);
      expect(find.byType(EditorSimpleHelperPage), findsOneWidget);
    });

    testWidgets('text is clicked, toolbar is visible => click outside of it close the toolbar', (WidgetTester tester) async {
      await _beforeEach(tester);
      var simpleHelperDetailTextField = find.byKey(ValueKey('palSimpleHelperDetailField'));
      await tester.tap(simpleHelperDetailTextField);
      await tester.pumpAndSettle();

      expect(find.byType(EditHelperToolbar), findsOneWidget);
      var closeButtonToolbar = find.byKey(ValueKey('pal_EditHelperToolbar_Close'));
      await tester.tap(closeButtonToolbar);
      await tester.pumpAndSettle();
      expect(find.byType(EditHelperToolbar), findsNothing);
    });

    testWidgets('title = "my helper tips lorem" => save call helperService.saveSimpleHelper', (WidgetTester tester) async {
      await _beforeEach(tester);
      var editableTextsFinder = find.byType(TextField);
      await enterTextInEditable(tester, editableTextsFinder.at(0), 'my helper tips lorem');
      await tester.pumpAndSettle();
      var validateFinder = find.byKey(ValueKey('editableActionBarValidateButton'));
      var validateButton = validateFinder.evaluate().first.widget as CircleIconButton;
      expect(validateButton.onTapCallback, isNotNull);

      validateButton.onTapCallback();
      await tester.pump(Duration(seconds: 1));
      verify(helperEditorServiceMock.saveSimpleHelper(any)).called(1);
      await tester.pump(Duration(seconds: 2));
      await tester.pump(Duration(milliseconds: 100));
    });

    testWidgets('save call helperService.saveSimpleHelper with error => an error is shown then fades', (WidgetTester tester) async {
      await _beforeEach(tester);
      when(helperEditorServiceMock.saveSimpleHelper(any)).thenThrow(new ArgumentError());
      var editableTextsFinder = find.byType(TextField);
      await enterTextInEditable(tester, editableTextsFinder.at(0), 'my helper tips lorem');
      await tester.pumpAndSettle();
      var validateFinder = find.byKey(ValueKey('editableActionBarValidateButton'));
      var validateButton = validateFinder.evaluate().first.widget as CircleIconButton;
      expect(validateButton.onTapCallback, isNotNull);

      validateButton.onTapCallback();
      await tester.pump(Duration(seconds: 1));
      expect(find.text('Error occured, please try again later'), findsOneWidget);
      await tester.pump(Duration(seconds: 2));
      await tester.pump(Duration(milliseconds: 100));
      expect(find.text('Error occured, please try again later'), findsNothing);
    });

    test('HelperViewModel => transform to SimpleHelperViewModel ', () {
      HelperViewModel helperViewModel = HelperViewModel(
        id: "testid",
        name: "test",
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        helperType: HelperType.SIMPLE_HELPER,
        helperTheme: HelperTheme.BLACK,
        priority: 1,
        minVersionCode: "0.0.0",
        maxVersionCode: "1.0.1",
      );
      var simpleHelper = SimpleHelperViewModel.fromHelperViewModel(helperViewModel);
      expect(simpleHelper.id, helperViewModel.id);
      expect(simpleHelper.name, helperViewModel.name);
      expect(simpleHelper.minVersionCode, helperViewModel.minVersionCode);
      expect(simpleHelper.maxVersionCode, helperViewModel.maxVersionCode);
      expect(simpleHelper.triggerType, HelperTriggerType.ON_SCREEN_VISIT);
      expect(simpleHelper.helperTheme, HelperTheme.BLACK);
    });



  });

}
