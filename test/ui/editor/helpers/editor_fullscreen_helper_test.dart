import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:pal/src/ui/editor/widgets/edit_helper_toolbar.dart';
import 'package:pal/src/ui/editor/widgets/editable_textfield.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';
import '../../../pal_test_utilities.dart';
import 'package:mockito/mockito.dart';

class HelperEditorServiceMock extends Mock implements EditorHelperService {}

class PalEditModeStateServiceMock extends Mock implements PalEditModeStateService {}

void main() {

  _enterTextInEditable(WidgetTester tester, Finder finder, String text) async{
    await tester.tap(finder);
    await tester.pump();
    await tester.enterText(finder, text);
  }


  group('[Editor] Fullscreen helper - creation mode', () {

    EditorFullScreenHelperPresenter presenter;

    final _navigatorKey = GlobalKey<NavigatorState>();

    HelperEditorServiceMock helperEditorServiceMock = HelperEditorServiceMock();

    Scaffold _overlayedApplicationPage = Scaffold(
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
      await initAppWithPal(tester, _overlayedApplicationPage, _navigatorKey);
      await pumpHelperWidget(
        tester, _navigatorKey,
        HelperTriggerType.ON_SCREEN_VISIT,
        HelperType.HELPER_FULL_SCREEN,
        HelperTheme.BLACK,
        editorHelperService: helperEditorServiceMock,
        palEditModeStateService: new PalEditModeStateServiceMock()
      );
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
      var presenterFinder = find.byKey(ValueKey("palEditorFullscreenHelperWidgetBuilder"));
      var page = presenterFinder.evaluate().first.widget
        as PresenterInherited<EditorFullScreenHelperPresenter, FullscreenHelperViewModel>;
      presenter = page.presenter;
    }

    // --------------------------------------------
    // Tests
    // --------------------------------------------

    testWidgets('should create', (WidgetTester tester) async {
      await _beforeEach(tester);
      expect(find.byType(EditorFullScreenHelperPage), findsOneWidget);
      expect(presenter, isNotNull);
      expect(presenter.editorHelperService, isNotNull);
    });

    testWidgets('title = "test title", description = "test description" '
      '=> save call helperService.saveFullscreen', (WidgetTester tester) async {
      await _beforeEach(tester);
      var editableTextsFinder = find.byType(TextField);
      var cancelFinder = find.byKey(ValueKey('editModeCancel'));
      var validateFinder = find.byKey(ValueKey('editModeValidate'));
      var validateButton = validateFinder.evaluate().first.widget as EditorButton;

      expect(validateButton.isEnabled, isFalse);
      await _enterTextInEditable(tester, editableTextsFinder.at(0), 'test title');
      await _enterTextInEditable(tester, editableTextsFinder.at(1), 'test description');

      validateButton = validateFinder.evaluate().first.widget as EditorButton;
      await tester.pumpAndSettle();
      expect(presenter.viewModel.titleField.text.value, equals('test title'));
      expect(presenter.viewModel.descriptionField.text.value, equals('test description'));
      expect(presenter.viewModel.positivButtonField.text.value, equals('Ok, thanks !'));
      expect(presenter.viewModel.negativButtonField.text.value, equals('This is not helping'));
      expect(validateButton.isEnabled, isTrue);
      validateButton.onPressed();
      await tester.pump(Duration(seconds: 1));
      verify(helperEditorServiceMock.saveFullScreenHelper(any)).called(1);
      await tester.pump(Duration(seconds: 2));
      await tester.pump(Duration(milliseconds: 100));
    });

    testWidgets('save call helperService.saveFullscreen with error => shows error overlay', (WidgetTester tester) async {
      await _beforeEach(tester);
      when(helperEditorServiceMock.saveFullScreenHelper(any)).thenThrow(ArgumentError());
      var editableTextsFinder = find.byType(TextField);
      var validateFinder = find.byKey(ValueKey('editModeValidate'));

      await _enterTextInEditable(tester, editableTextsFinder.at(0), 'test title');
      await _enterTextInEditable(tester, editableTextsFinder.at(1), 'test description');
      await tester.pumpAndSettle();
      var validateButton = validateFinder.evaluate().first.widget as EditorButton;
      expect(validateButton.isEnabled, isTrue);
      validateButton.onPressed();
      await tester.pump(Duration(seconds: 1));
      expect(find.text('Error occured, please try again later'), findsOneWidget);
      await tester.pump(Duration(seconds: 2));
      await tester.pump(Duration(milliseconds: 100));
    });

    testWidgets('background color = Colors.blueAccent, change color to FFF => should change background color in model', (WidgetTester tester) async {
      await _beforeEach(tester);
      expect(presenter.viewModel.bodyBox.backgroundColor.value, Colors.blueAccent,);
      var colorPickerButton = find.byKey(ValueKey('pal_EditorFullScreenHelperPage_BackgroundColorPicker'));
      await tester.tap(colorPickerButton);
      await tester.pumpAndSettle();
      expect(find.byType(ColorPickerDialog), findsOneWidget);

      var hecColorField = find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
      await tester.enterText(hecColorField, '#FFFFFF');
      await tester.pumpAndSettle();

      var validateColorButton = find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'));
      await tester.tap(validateColorButton);
      await tester.pumpAndSettle();
      expect(presenter.viewModel.bodyBox.backgroundColor.value, Color(0xFFFFFFFF),);
    });

    testWidgets('tap on on field, tap on a second field => only one toolbar is shown', (WidgetTester tester) async {
      await _beforeEach(tester);
      var textFinder = find.byType(EditableTextField);
      var text1 = textFinder.evaluate().first.widget as EditableTextField;
      var text2 = textFinder.evaluate().elementAt(1).widget as EditableTextField;
      expect(find.byType(EditHelperToolbar), findsNothing);
      expect(textFinder, findsNWidgets(4));

      await tester.tap(find.byType(EditableTextField).first);
      await tester.pump(Duration(seconds: 1));
      expect(find.byType(EditHelperToolbar), findsOneWidget);

      text2.toolbarVisibility.value = true;
      await tester.pump(Duration(seconds: 1));
      expect(find.byType(EditHelperToolbar), findsOneWidget);
      
      await tester.pump(Duration(seconds: 1));
    });

    test('HelperViewModel => transform to FullscreenHelperViewModel ', () {
      HelperViewModel helperViewModel = HelperViewModel(
        id: "testid",
        name: "test",
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        helperType: HelperType.HELPER_FULL_SCREEN,
        helperTheme: HelperTheme.BLACK,
        priority: 1,
        minVersionCode: "0.0.0",
        maxVersionCode: "1.0.1",
      );
      var helper = FullscreenHelperViewModel.fromHelperViewModel(helperViewModel);
      expect(helper.id, helperViewModel.id);
      expect(helper.name, helperViewModel.name);
      expect(helper.minVersionCode, helperViewModel.minVersionCode);
      expect(helper.maxVersionCode, helperViewModel.maxVersionCode);
      expect(helper.triggerType, HelperTriggerType.ON_SCREEN_VISIT);
      expect(helper.helperTheme, HelperTheme.BLACK);
    });

  });

  group('[Editor] Fullscreen helper - update mode', () {

    EditorFullScreenHelperPresenter presenter;

    HelperEditorServiceMock helperEditorServiceMock = HelperEditorServiceMock();

    HelperEntity validFullscreenHelperEntity()
      => HelperEntity(
        id: "JDLSKJDSD",
        name: "fullscreen test",
        type: HelperType.HELPER_FULL_SCREEN,
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        priority: 1,
        versionMinId: 25,
        versionMaxId: 25,
        helperTexts: [
          HelperTextEntity(
            value: "title text",
            fontColor: "#CCCCCC",
            fontWeight: "w100",
            fontSize: 21,
            fontFamily: "Montserrat",
            key: FullscreenHelperKeys.TITLE_KEY,
          ),
          HelperTextEntity(
            value: "description text",
            fontColor: "#FFFFFF",
            fontWeight: "w100",
            fontSize: 18,
            fontFamily: "Montserrat",
            key: FullscreenHelperKeys.DESCRIPTION_KEY,
          ),
        ],
        helperImages: [
          HelperImageEntity(
            url: null,
            key: FullscreenHelperKeys.IMAGE_KEY,
          )
        ],
        helperBoxes: [
          HelperBoxEntity(
            key: FullscreenHelperKeys.BACKGROUND_KEY,
            backgroundColor: "#000000",
          )
        ],
      );

    Future _beforeEach(WidgetTester tester, HelperEntity helperEntity) async {
      reset(helperEditorServiceMock);
      EditorFullScreenHelperPage editor = EditorFullScreenHelperPage.edit(
        palEditModeStateService: PalEditModeStateServiceMock(),
        helperEntity: helperEntity,
        parameters: HelperEditorPageArguments(
          null,
          "pageId_IEPZE",
          helperMinVersion: "1.0.1",
          helperMaxVersion: null
        ) ,
        helperService: helperEditorServiceMock,
      );
      await tester.pumpWidget(
        PalTheme(
          theme: PalThemeData.light(),
          child: MaterialApp(
            home: Overlayed(child: editor)
          ),
        )
      );
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
      var presenterFinder = find.byKey(ValueKey("palEditorFullscreenHelperWidgetBuilder"));
      var page = presenterFinder.evaluate().first.widget
      as PresenterInherited<EditorFullScreenHelperPresenter, FullscreenHelperViewModel>;
      presenter = page.presenter;
    }
    
    testWidgets('valid fullscreen helper entity => fill all text in editor', (WidgetTester tester) async {
      var entity = validFullscreenHelperEntity();
      await _beforeEach(tester, entity);
      entity.helperTexts.forEach((element) => expect(find.text(element.value), findsOneWidget));
    });
    
    
  });
}
