import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/client/helpers/user_anchored_helper/anchored_helper_widget.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_anchored_helper/editor_anchored_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_anchored_helper/editor_anchored_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_anchored_helper/editor_anchored_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_actionsbar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_tutorial.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_modal.dart';
import 'package:pal/src/ui/editor/widgets/bubble_overlay.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import '../../screen_tester_utilities.dart';
import 'package:pal/src/extensions/color_extension.dart';
import '../../../pal_test_utilities.dart';

class HelperEditorServiceMock extends Mock implements EditorHelperService {}

class PalEditModeStateServiceMock extends Mock implements PalEditModeStateService {}

void main() {

  _enterTextInEditable(WidgetTester tester, Finder finder, String text) async {
    await tester.tap(finder);
    await tester.pump();
    await tester.enterText(finder, text);
  }

  _getAnchorFullscreenPainter()
    => find.byType(AnimatedAnchoredFullscreenCircle).evaluate().first.widget as AnimatedAnchoredFullscreenCircle;

  _getActionBar()
    => find.byType(EditorActionsBar).evaluate().first.widget as EditorActionsBar;

  group('[Editor] save Anchored helper', () {

    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorAnchoredFullscreenPresenter presenter;

    HelperEditorServiceMock helperEditorServiceMock = HelperEditorServiceMock();

    Scaffold _myHomeTest = Scaffold(
      body: Column(
        children: [
          Text("text1", key: ValueKey("text1")),
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

    // init pal + go to editor
    Future beforeEach(WidgetTester tester) async {
      await initAppWithPal(tester, _myHomeTest, _navigatorKey);
      await pumpHelperWidget(
        tester,
        _navigatorKey,
        HelperTriggerType.ON_SCREEN_VISIT,
        HelperType.ANCHORED_OVERLAYED_HELPER,
        HelperTheme.BLACK,
        editorHelperService: helperEditorServiceMock,
        palEditModeStateService: new PalEditModeStateServiceMock()
      );
      await tester.pump(Duration(milliseconds: 100));
      var presenterFinder = find.byKey(ValueKey("EditorAnchoredFullscreenHelperPage"));
      expect(presenterFinder, findsOneWidget);
      presenter = (presenterFinder.evaluate().first.widget
        as PresenterInherited<EditorAnchoredFullscreenPresenter, AnchoredFullscreenHelperViewModel>).presenter;
      await tester.pump(Duration(milliseconds: 100));
    }

    Future closeFirstStepTutorial(WidgetTester tester) async {
      await tester.pump(Duration(seconds: 2));
      var btn = find.byKey(ValueKey("tutorialBtnDiss")).evaluate().first.widget as OutlineButton;
      btn.onPressed();
      await tester.pump();
    }

    testWidgets('can add an anchored fullscreen helper', (WidgetTester tester) async {
      await beforeEach(tester);
      // expect to find only our helper type editor
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
    });

    testWidgets('a step 1 tutorial message is show, tap close => tutorial is dimissed', (WidgetTester tester) async {
      await beforeEach(tester);
      // expect to find only our helper type editor
      expect(find.byType(EditorTutorialOverlay), findsOneWidget);
      await closeFirstStepTutorial(tester);
      expect(find.byType(EditorTutorialOverlay), findsNothing);
    });

    testWidgets('shows one container with borders for each element of user app page', (WidgetTester tester) async {
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      var refreshFinder = find.byKey(ValueKey("refreshButton"));
      expect(refreshFinder, findsOneWidget);
      // await tester.tap(refreshFinder);
      expect(find.byKey(ValueKey("elementContainer")), findsWidgets);
    });

    testWidgets("step 1 => tap on container's element select it as anchor", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      var element2 = elementsFinder.evaluate().elementAt(2).widget as InkWell;
      element1.onTap();
      await tester.pump();
      await tester.pump();
      // expect first element to be selected
      expect(presenter.viewModel.selectedAnchorKey, contains("text1"));
      // expect second element to be selected
      element2.onTap();
      await tester.pump(Duration(milliseconds: 100));
      expect(presenter.viewModel.selectedAnchorKey, contains("text2"));
    });

    testWidgets("anchored selected => shows confirm selection button, helper text are not visible yet", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      element1.onTap();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(ValueKey("validateSelectionBtn")), findsOneWidget);
      expect(find.text("My helper title"), findsNothing);
      expect(find.text("Lorem ipsum lorem ipsum lorem ipsum"), findsNothing);
      expect(find.text("Ok, thanks!"), findsNothing, reason: "A positiv feedback button is available");
      expect(find.text("This is not helping"), findsNothing, reason: "A negativ feedback button is available");
    });

    testWidgets("anchored selected and validated => confirm selection button is hidden, "
      "helper text are now visible, background is 100%, selectable element's borders are hidden,"
      "EditorActionsBar is visible ", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // action bar is not visible
      expect(_getActionBar().visible, isFalse);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      element1.onTap();
      await tester.pump(Duration(milliseconds: 100));
      await tester.pump(Duration(milliseconds: 100));
      // validate this anchor
      await tester.tap(find.byKey(ValueKey("validateSelectionBtn")));
      await tester.pump(Duration(milliseconds: 100));

      expect(find.byKey(ValueKey("elementContainer")), findsNothing);
      expect(_getActionBar().visible, isTrue);
      expect(find.byKey(ValueKey("validateSelectionBtn")), findsNothing);
      expect(presenter.viewModel.backgroundBox.backgroundColor.value.opacity, 1);
      expect(find.text("My helper title"), findsOneWidget);
      expect(find.text("Lorem ipsum lorem ipsum lorem ipsum"), findsOneWidget);
      expect(find.text("Ok, thanks!"), findsOneWidget, reason: "A positiv feedback button is available");
      expect(find.text("This is not helping"), findsOneWidget, reason: "A negativ feedback button is available");
    });

    testWidgets("anchored selected and validated => cannot change anchor selection anymore", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      var element2 = elementsFinder.evaluate().elementAt(2).widget as InkWell;
      element1.onTap();
      await tester.pump(Duration(milliseconds: 100));
      await tester.pump(Duration(milliseconds: 100));
      // validate this anchor
      await tester.tap(find.byKey(ValueKey("validateSelectionBtn")));
      await tester.pump(Duration(milliseconds: 100));
      element2.onTap();
      expect(presenter.viewModel.selectedAnchorKey, contains("text1"));
    });

    testWidgets("step 2 => title, description positiv button, negative button can be edited", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      element1.onTap();
      await tester.pump();
      await tester.pump();
      // validate this anchor
      await tester.tap(find.byKey(ValueKey("validateSelectionBtn")));
      await tester.pump(Duration(milliseconds: 100));
      var editableTextsFinder = find.byType(TextField);
      await _enterTextInEditable(tester, editableTextsFinder.at(0), 'test title edited');
      await _enterTextInEditable(tester, editableTextsFinder.at(1), 'test description edited');
      await _enterTextInEditable(tester, editableTextsFinder.at(2), 'negativ edit');
      await _enterTextInEditable(tester, editableTextsFinder.at(3), 'positiv edit');
      await tester.pump();
      expect(presenter.viewModel.titleField.text.value, equals('test title edited'));
      expect(presenter.viewModel.descriptionField.text.value, equals('test description edited'));
      expect(presenter.viewModel.negativBtnField.text.value, equals('negativ edit'));
      expect(presenter.viewModel.positivBtnField.text.value, equals('positiv edit'));
    });

    testWidgets("step 2 => title, description positiv button, negative button can change color", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      element1.onTap();
      await tester.pump();
      await tester.pump();
      // validate this anchor
      await tester.tap(find.byKey(ValueKey("validateSelectionBtn")));
      await tester.pump(Duration(milliseconds: 100));
      var editableTextsFinder = find.byType(TextField);
      //TODO
    });

    testWidgets("step 2 change background color to white => color has changed in model to white", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      element1.onTap();
      await tester.pump();
      await tester.pump();
      // validate this anchor
      await tester.tap(find.byKey(ValueKey("validateSelectionBtn")));
      await tester.pump(Duration(milliseconds: 100));
      expect(presenter.viewModel.backgroundBox.backgroundColor.value, isNot(Color(0xFFFFFFFF)));
      // open color picker
      var colorPickerButton = find.byKey(ValueKey('bgColorPicker'));
      await tester.tap(colorPickerButton);
      await tester.pump();
      expect(find.byType(ColorPickerDialog), findsOneWidget);
      // set a new color (fff)
      var hecColorField = find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
      await tester.enterText(hecColorField, '#FFFFFF');
      await tester.pump();
      // call validate - color is white
      var validateColorButton = find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'));
      await tester.tap(validateColorButton);
      await tester.pump();

      expect(_getAnchorFullscreenPainter().bgColor, Color(0xFFFFFFFF));
      expect(presenter.viewModel.backgroundBox.backgroundColor.value, Color(0xFFFFFFFF));
    });

    testWidgets("step 2 click on save => call helper service saveAnchoredHelper", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      element1.onTap();
      await tester.pump();
      await tester.pump();
      // validate this anchor
      await tester.tap(find.byKey(ValueKey("validateSelectionBtn")));
      await tester.pump(Duration(milliseconds: 100));
      // enter texts
      var editableTextsFinder = find.byType(TextField);
      await _enterTextInEditable(tester, editableTextsFinder.at(0), 'Today tip');
      await _enterTextInEditable(tester, editableTextsFinder.at(1), 'test description');
      await _enterTextInEditable(tester, editableTextsFinder.at(2), 'Not');
      await _enterTextInEditable(tester, editableTextsFinder.at(3), 'Ok');
      await tester.pump();
      // save anchor
      var validateFinder = find.byKey(ValueKey('editModeValidate'));
      var validateButton = validateFinder.evaluate().first.widget as EditorButton;
      expect(validateButton.isEnabled, isTrue);
      await tester.pump(Duration(seconds: 1));
      validateButton.onPressed();
      var args = CreateAnchoredHelper(
        config: CreateHelperConfig(
          name: 'helper name',
          triggerType: HelperTriggerType.ON_SCREEN_VISIT,
          priority: 1,
          minVersion: "1.0.0",
          maxVersion: "1.0.0",
          route: "widget.pageId",
          helperType: HelperType.ANCHORED_OVERLAYED_HELPER,
        ),
        title: HelperTextConfig(
          text: "Today tip",
          fontColor: Colors.white.toHex(),
          fontWeight: "Normal",
          fontSize: 31,
          fontFamily: "cortana",
        ),
        description: HelperTextConfig(
          text: "test description",
          fontColor: Colors.white.toHex(),
          fontWeight: "Normal",
          fontSize: 20,
          fontFamily: "cortana",
        ),
        positivButton: HelperTextConfig(
          text: "Ok",
          fontColor: Colors.white.toHex(),
          fontWeight: "Normal",
          fontSize: 20,
          fontFamily: "cortana",
        ),
        negativButton: HelperTextConfig(
          text: "Not",
          fontColor: Colors.white.toHex(),
          fontWeight: "Normal",
          fontSize: 15,
          fontFamily: "cortana",
        ),
        bodyBox: HelperBoxConfig(
          key: "[<'text1'>]",
          color: Colors.blueGrey.shade900.toHex(),
        )
      );
      await tester.pump(Duration(seconds: 2));
      await tester.pump(Duration(milliseconds: 100));
      var capturedCall = verify(helperEditorServiceMock.saveAnchoredWidget(captureAny)).captured;
      expect(jsonEncode(capturedCall.first), equals(jsonEncode(args)));
      await tester.pumpAndSettle(Duration(seconds: 1));
    });

    testWidgets('step 2 tap cancel button editor => page is removed, page helpers list is visible', (WidgetTester tester) async {
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      element1.onTap();
      await tester.pump();
      await tester.pump();
      // validate this anchor
      await tester.tap(find.byKey(ValueKey("validateSelectionBtn")));
      await tester.pump(Duration(milliseconds: 100));
      // tap cancel
      var cancelFinder = find.byKey(ValueKey('editModeCancel'));
      await tester.tap(cancelFinder);
      await tester.pumpAndSettle();
      expect(find.byType(EditorAnchoredFullscreenHelper), findsNothing);
      expect(find.byType(HelpersListModal), findsOneWidget);
    });

  });

  group('[Editor] update Anchored helper', () {

    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorAnchoredFullscreenPresenter presenter;

    HelperEditorServiceMock helperEditorServiceMock = HelperEditorServiceMock();

    Scaffold _myHomeTest = Scaffold(
      body: Column(
        children: [
          Text("text1", key: ValueKey("text1")),
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

    var helperEntity = HelperEntity(
      id:"myhelperid",
      name: "my helper name",
      type: HelperType.ANCHORED_OVERLAYED_HELPER,
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      priority: 1,
      versionMinId: 25,
      versionMaxId: 25,
      helperTexts: [
        HelperTextEntity(
          value: "args.title.text",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.TITLE_KEY,
        ),
        HelperTextEntity(
          value: "args.title.descr",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.DESCRIPTION_KEY,
        ),
        HelperTextEntity(
          value: "ok",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.POSITIV_KEY,
        ),
        HelperTextEntity(
          value: "not_ok",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.NEGATIV_KEY,
        ),
      ],
      helperBoxes: [
        HelperBoxEntity(
          key: "[<'text1'>]",
          backgroundColor: Colors.black.toHex(),
        )
      ]
    );

    var helperEntityKeyNotFound = HelperEntity(
      id: "myhelperid",
      name: "my helper name",
      type: HelperType.ANCHORED_OVERLAYED_HELPER,
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      priority: 1,
      versionMinId: 25,
      versionMaxId: 25,
      helperTexts: [
        HelperTextEntity(
          value: "args.title.text",
          fontColor: "FFFFFF",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.TITLE_KEY,
        ),
        HelperTextEntity(
          value: "args.title.descr",
          fontColor: "FFFFFF",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.DESCRIPTION_KEY,
        ),
        HelperTextEntity(
          value: "ok",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.POSITIV_KEY,
        ),
        HelperTextEntity(
          value: "not_ok",
          fontColor: "ffffffff",
          fontWeight: "Normal",
          fontSize: 21,
          fontFamily: "Montserrat",
          key: AnchoredscreenHelperKeys.NEGATIV_KEY,
        ),
      ],
      helperBoxes: [
        HelperBoxEntity(
          key: "[<'notfoundkey'>]",
          backgroundColor: Colors.black.toHex(),
        )
      ]
    );


    // init pal + go to editor
    Future beforeEach(WidgetTester tester, HelperEntity helperEntity) async {
      await initAppWithPal(tester, _myHomeTest, _navigatorKey);
      await pumpHelperWidget(
        tester,
        _navigatorKey,
        HelperTriggerType.ON_SCREEN_VISIT,
        HelperType.ANCHORED_OVERLAYED_HELPER,
        HelperTheme.BLACK,
        editorHelperService: helperEditorServiceMock,
        palEditModeStateService: new PalEditModeStateServiceMock(),
        helperEntity: helperEntity
      );
      await tester.pump(Duration(milliseconds: 100));
      var presenterFinder = find.byKey(ValueKey("EditorAnchoredFullscreenHelperPage"));
      expect(presenterFinder, findsOneWidget);
      presenter = (presenterFinder.evaluate().first.widget
        as PresenterInherited<EditorAnchoredFullscreenPresenter, AnchoredFullscreenHelperViewModel>).presenter;
      await tester.pump(Duration(milliseconds: 100));
    }

    testWidgets('anchor key is found => anchored helper is created directly on step 2, no tutorial message', (WidgetTester tester) async {
      await beforeEach(tester, helperEntity);
      await tester.pump();
      await tester.pump();
      // expect to find only our helper type editor
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
      // action bar is visible only on step 2
      expect(_getActionBar().visible, isTrue);
      expect(find.byType(EditorTutorialOverlay), findsNothing);
    });

    testWidgets('anchor key is not found => editor stays on step 1 with an error', (WidgetTester tester) async {
      await beforeEach(tester, helperEntityKeyNotFound);
      await tester.pump();
      await tester.pump();
      // expect to find only our helper type editor
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
      // action bar is visible only on step 2
      expect(_getActionBar().visible, isFalse);
    });

    testWidgets('anchor key is found => all texts are correctly set, background color is correct', (WidgetTester tester) async {
      await beforeEach(tester, helperEntity);
      await tester.pump();
      await tester.pump();
      helperEntity.helperTexts.forEach((element) {
        var textWidget = find.text(element.value).evaluate().first.widget as EditableText;
        expect(textWidget, isNotNull);
        expect(textWidget.style.color.toHex(), element.fontColor);
        expect(textWidget.style.fontWeight, FontWeightMapper.toFontWeight(element.fontWeight));
        expect(textWidget.style.fontFamily, contains(element.fontFamily));
        expect(textWidget.style.fontSize, element.fontSize);
      });
      expect(presenter.viewModel.backgroundBox.backgroundColor.value, equals(Colors.black));
      expect(presenter.viewModel.anchorValidated, isTrue);
    });

  });
}
