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
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_anchored_helper/editor_anchored_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_anchored_helper/editor_anchored_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_anchored_helper/editor_anchored_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_textfield.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_action_bar/editor_action_bar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_action_bar/widgets/editor_action_item.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/color_picker/color_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_tutorial.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_modal.dart';
import 'package:pal/src/ui/editor/widgets/edit_helper_toolbar.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';
import '../../../../screen_tester_utilities.dart';
import 'package:pal/src/extensions/color_extension.dart';
import '../../../../../pal_test_utilities.dart';

class HelperEditorServiceMock extends Mock implements EditorHelperService {}

class PalEditModeStateServiceMock extends Mock
    implements PalEditModeStateService {}

void main() {
  _getAnchorFullscreenPainter() =>
      find.byType(AnimatedAnchoredFullscreenCircle).evaluate().first.widget
          as AnimatedAnchoredFullscreenCircle;

  _getActionBar() =>
      find.byType(EditorActionBar).evaluate().first.widget as EditorActionBar;

  group('[Editor] save Anchored helper', () {
    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorAnchoredFullscreenPresenter presenter;

    HelperEditorServiceMock helperEditorServiceMock = HelperEditorServiceMock();

    Widget _myHomeTest = MaterialApp(
        home: Scaffold(
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
    ));

    // init pal + go to editor
    Future beforeEach(WidgetTester tester) async {
      var routeFactory = (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => _myHomeTest,
            );
          case '/editor/preview':
            EditorPreviewArguments args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => EditorPreviewPage(
                previewHelper: args.previewHelper,
              ),
            );
        }
      };
      await initAppWithPal(tester, null, _navigatorKey,
          routeFactory: routeFactory);
      await pumpHelperWidget(
          tester,
          _navigatorKey,
          HelperTriggerType.ON_SCREEN_VISIT,
          HelperType.ANCHORED_OVERLAYED_HELPER,
          HelperTheme.BLACK,
          editorHelperService: helperEditorServiceMock,
          palEditModeStateService: new PalEditModeStateServiceMock());
      await tester.pump(Duration(milliseconds: 100));
      var presenterFinder =
          find.byKey(ValueKey("EditorAnchoredFullscreenHelperPage"));
      expect(presenterFinder, findsOneWidget);
      presenter = (presenterFinder.evaluate().first.widget
              as PresenterInherited<EditorAnchoredFullscreenPresenter,
                  AnchoredFullscreenHelperViewModel>)
          .presenter;
      await tester.pump(Duration(milliseconds: 100));
    }

    Future closeFirstStepTutorial(WidgetTester tester) async {
      await tester.pump(Duration(seconds: 2));
      var btn = find.byKey(ValueKey("tutorialBtnDiss")).evaluate().first.widget
          as OutlineButton;
      btn.onPressed();
      await tester.pump();
    }

    Future _passFirstStep(WidgetTester tester) async {
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
    }

    Future _passSecondStep(
      WidgetTester tester,
      String firstField,
      String secondField,
      String thirdField,
      String fourthField,
    ) async {
      // // INIT TEXTFIELDS
      await enterTextInTextForm(tester, 0, firstField);
      await enterTextInTextForm(tester, 1, secondField);
      await enterTextInTextForm(tester, 0, thirdField, button: true);
      await enterTextInTextForm(tester, 1, fourthField, button: true);
      // presenter.viewModel.titleField.text = firstField;
      // presenter.viewModel.descriptionField.text = secondField;
      // presenter.viewModel.negativBtnField.text = thirdField;
      // presenter.viewModel.positivBtnField.text = fourthField;
      await tester.pump();
      // INIT TEXTFIELDS
    }

    testWidgets('can add an anchored fullscreen helper',
        (WidgetTester tester) async {
      await beforeEach(tester);
      // expect to find only our helper type editor
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
    });

    testWidgets('on text press  => button is disabled',
        (WidgetTester tester) async {
      await beforeEach(tester);
      await _passFirstStep(tester);

      final textButtonFinder =
          find.byKey(ValueKey('editableActionBarTextButton'));
      final textButton =
          textButtonFinder.evaluate().first.widget as EditorActionItem;
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
      expect(textButton.onTap, isNull);
    });

    testWidgets('on settings press  => button is disabled',
        (WidgetTester tester) async {
      await beforeEach(tester);
      await _passFirstStep(tester);
      final settingsButtonFinder =
          find.byKey(ValueKey('editableActionBarSettingsButton'));
      final settingsButton =
          settingsButtonFinder.evaluate().first.widget as EditorActionItem;
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
      expect(settingsButton.onTap, isNull);
    });

    testWidgets(
        'on preview press  => show anchored client preview & cancel with positiv button',
        (WidgetTester tester) async {
      await beforeEach(tester);
      await _passFirstStep(tester);

      final String firstField = 'test title edited';
      final String secondField = 'test description edited';
      final String thirdField = 'negativ edit';
      final String fourthField = 'positiv edit';
      await _passSecondStep(
          tester, firstField, secondField, thirdField, fourthField);


      final previewButtonFinder =
          find.byKey(ValueKey('editableActionBarPreviewButton'));
      final previewButton =
          previewButtonFinder.evaluate().first.widget as EditorActionItem;
      previewButton.onTap();
      // await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 1));
      await tester.pump(Duration(seconds: 2));


      expect(find.byKey(ValueKey('EditorPreviewPage_Builder')), findsOneWidget);

      Finder titleFinder = find.byKey(ValueKey('pal_AnchoredHelperTitleLabel'));
      expect(titleFinder, findsOneWidget);
      Text titleText = tester.widget(titleFinder);
      expect(titleText.data, equals('test title edited'));

      Finder descriptionFinder =
          find.byKey(ValueKey('pal_AnchoredHelperDescriptionLabel'));
      expect(descriptionFinder, findsOneWidget);
      Text descriptionText = tester.widget(descriptionFinder);
      expect(descriptionText.data, equals('test description edited'));

      Finder negativFinder =
          find.byKey(ValueKey('pal_AnchoredHelperNegativFeedbackLabel'));
      expect(negativFinder, findsOneWidget);
      Text negativText = tester.widget(negativFinder);
      expect(negativText.data, equals('negativ edit'));

      Finder positivFinder =
          find.byKey(ValueKey('pal_AnchoredHelperPositivFeedbackLabel'));
      expect(positivFinder, findsOneWidget);
      Text positivText = tester.widget(positivFinder);
      expect(positivText.data, equals('positiv edit'));

      expect(find.byKey(ValueKey("EditorAnchoredFullscreenHelperPage")), findsOneWidget);

      (tester.widget(find.byKey(ValueKey("positiveFeedback"))) as RaisedButton)
          .onPressed();

      await tester.pump(Duration(milliseconds: 1000));
      await tester.pump(Duration(milliseconds: 2000));

      expect(find.byKey(ValueKey('EditorPreviewPage_Builder')), findsNothing);
    });

    testWidgets(
        'on preview press  => show anchored client preview & cancel with negativ button',
        (WidgetTester tester) async {
      await beforeEach(tester);
      await _passFirstStep(tester);

      final String firstField = 'test title edited';
      final String secondField = 'test description edited';
      final String thirdField = 'negativ edit';
      final String fourthField = 'positiv edit';
      await _passSecondStep(
          tester, firstField, secondField, thirdField, fourthField);

      final previewButtonFinder =
          find.byKey(ValueKey('editableActionBarPreviewButton'));
      final previewButton =
          previewButtonFinder.evaluate().first.widget as EditorActionItem;
      previewButton.onTap();
      // await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 1));
      await tester.pump(Duration(seconds: 2));

      expect(find.byKey(ValueKey('EditorPreviewPage_Builder')), findsOneWidget);

      Finder titleFinder = find.byKey(ValueKey('pal_AnchoredHelperTitleLabel'));
      expect(titleFinder, findsOneWidget);
      Text titleText = tester.widget(titleFinder);
      expect(titleText.data, equals('test title edited'));

      Finder descriptionFinder =
          find.byKey(ValueKey('pal_AnchoredHelperDescriptionLabel'));
      expect(descriptionFinder, findsOneWidget);
      Text descriptionText = tester.widget(descriptionFinder);
      expect(descriptionText.data, equals('test description edited'));

      Finder negativFinder =
          find.byKey(ValueKey('pal_AnchoredHelperNegativFeedbackLabel'));
      expect(negativFinder, findsOneWidget);
      Text negativText = tester.widget(negativFinder);
      expect(negativText.data, equals('negativ edit'));

      Finder positivFinder =
          find.byKey(ValueKey('pal_AnchoredHelperPositivFeedbackLabel'));
      expect(positivFinder, findsOneWidget);
      Text positivText = tester.widget(positivFinder);
      expect(positivText.data, equals('positiv edit'));

      (tester.widget(find.byKey(ValueKey("negativeFeedback"))) as RaisedButton)
          .onPressed();
      await tester.pump(Duration(milliseconds: 1000));
      await tester.pump(Duration(milliseconds: 2000));

      expect(find.byKey(ValueKey('EditorPreviewPage_Builder')), findsNothing);
    });

    testWidgets(
        'a step 1 tutorial message is show, tap close => tutorial is dimissed',
        (WidgetTester tester) async {
      await beforeEach(tester);
      // expect to find only our helper type editor
      expect(find.byType(EditorTutorialOverlay), findsOneWidget);
      await closeFirstStepTutorial(tester);
      expect(find.byType(EditorTutorialOverlay), findsNothing);
    });

    testWidgets(
        'shows one container with borders for each element of user app page',
        (WidgetTester tester) async {
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      var refreshFinder = find.byKey(ValueKey("refreshButton"));
      expect(refreshFinder, findsOneWidget);
      // await tester.tap(refreshFinder);
      expect(find.byKey(ValueKey("elementContainer")), findsWidgets);
    });

    testWidgets("step 1 => tap on container's element select it as anchor",
        (WidgetTester tester) async {
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

    testWidgets(
        "anchored selected => shows confirm selection button, helper text are not visible yet",
        (WidgetTester tester) async {
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
      expect(find.text("Describe your element here"), findsNothing);
      expect(find.text("Ok, thanks!"), findsNothing,
          reason: "A positiv feedback button is available");
      expect(find.text("This is not helping"), findsNothing,
          reason: "A negativ feedback button is available");
    });

    testWidgets(
        "anchored selected and validated => confirm selection button is hidden, "
        "helper text are now visible, background is 100%, selectable element's borders are hidden,"
        "EditorActionsBar is visible ", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      await closeFirstStepTutorial(tester);
      // action bar is not visible
      expect(find.byType(EditorActionBar),findsNothing);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      element1.onTap();
      await tester.pump(Duration(milliseconds: 100));
      await tester.pump(Duration(milliseconds: 100));
      // validate this anchor
      await tester.tap(find.byKey(ValueKey("validateSelectionBtn")));
      await tester.pump(Duration(milliseconds: 100));

      await _passSecondStep(tester, "My helper title", "Describe your element here", "Ok, thanks!", "This is not helping");
      expect(find.byKey(ValueKey("elementContainer")), findsNothing);
      expect(find.byType(EditorActionBar),findsOneWidget);
      // expect(_getActionBar().animation.value, equals(0));
      expect(find.byKey(ValueKey("validateSelectionBtn")), findsNothing);
      expect(presenter.viewModel.backgroundBox.backgroundColor.opacity, 1);
      expect(find.text("My helper title"), findsOneWidget);
      expect(find.text("Describe your element here"), findsOneWidget);
      expect(find.text("Ok, thanks!"), findsOneWidget,
          reason: "A positiv feedback button is available");
      expect(find.text("This is not helping"), findsOneWidget,
          reason: "A negativ feedback button is available");
    });

    testWidgets(
        "anchored selected and validated => cannot change anchor selection anymore",
        (WidgetTester tester) async {
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

    testWidgets(
        "step 2 => title, description positiv button, negative button can be edited",
        (WidgetTester tester) async {
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
      // var editableTextsFinder = find.byType(TextField);
      // await enterTextInTextForm(tester, 0, 'test title edited');
      // await enterTextInTextForm(tester, 1, 'test description edited');
      // await enterTextInTextForm(tester, 2, 'negativ edit');
      // await enterTextInTextForm(tester, 3, 'positiv edit');
      await _passSecondStep(tester, 'test title edited', 'test description edited',
          'negativ edit', 'positiv edit');

      await tester.pump();
      expect(presenter.viewModel.titleField.text, equals('test title edited'));
      expect(presenter.viewModel.descriptionField.text,
          equals('test description edited'));
      expect(presenter.viewModel.negativBtnField.text, equals('negativ edit'));
      expect(presenter.viewModel.positivBtnField.text, equals('positiv edit'));
    });

    testWidgets(
        "step 2 change background color to white => color has changed in model to white",
        (WidgetTester tester) async {
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
      expect(presenter.viewModel.backgroundBox.backgroundColor,
          isNot(Color(0xFFFFFFFF)));
      // open color picker
      var colorPickerButton = find.byKey(ValueKey('EditorToolBar_GlobalAction_BackgroundColor'));
      await tester.tap(colorPickerButton);
      await tester.pump();
      expect(find.byType(ColorPickerDialog), findsOneWidget);
      // set a new color (fff)
      var hecColorField =
          find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
      await tester.enterText(hecColorField, '#FFFFFF');
      await tester.pump();
      // call validate - color is white
      var validateColorButton =
          find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'));
      await tester.tap(validateColorButton);
      await tester.pump(Duration(milliseconds: 100));

      expect(_getAnchorFullscreenPainter().bgColor, Color(0xFFFFFFFF));
      expect(presenter.viewModel.backgroundBox.backgroundColor,
          Color(0xFFFFFFFF));
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
      // var editableTextsFinder = find.byType(TextField);
      // await enterTextInTextForm(tester, 0, 'Today tip');
      // await enterTextInTextForm(tester, 1, 'test description');
      // await enterTextInTextForm(tester, 2, 'Not');
      // await enterTextInTextForm(tester, 3, 'Ok');
      await _passSecondStep(tester, 'Today tip', 'test description', 'Not', 'Ok');
      await tester.pump();
      // save anchor
      var validateFinder =
          find.byKey(ValueKey('editableActionBarValidateButton'));
      var validateButton =
          validateFinder.evaluate().first.widget as CircleIconButton;
      expect(validateButton.onTapCallback, isNotNull);
      await tester.pump(Duration(seconds: 1));
      validateButton.onTapCallback();
      var args = CreateAnchoredHelper(
          helperGroup: HelperGroupConfig(
            id: "8209839023",
            minVersion: "1.0.0",
            maxVersion: "1.0.0"
          ),
          config: CreateHelperConfig(
            name: 'helper name',
            triggerType: HelperTriggerType.ON_SCREEN_VISIT,
            priority: 1,
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
          ));
      await tester.pump(Duration(seconds: 2));
      await tester.pump(Duration(milliseconds: 100));
      var capturedCall =
          verify(helperEditorServiceMock.saveAnchoredWidget(captureAny))
              .captured;
      expect(jsonEncode(capturedCall.first), equals(jsonEncode(args)));
      await tester.pumpAndSettle(Duration(seconds: 1));
    });

    testWidgets(
        'step 2 tap cancel button editor => page is removed, page helpers list is visible',
        (WidgetTester tester) async {
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
      var cancelFinder = find.byKey(ValueKey('editableActionBarCancelButton'));
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
        id: "myhelperid",
        name: "my helper name",
        type: HelperType.ANCHORED_OVERLAYED_HELPER,
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        priority: 1,
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
            id: 0,
            key: "[<'text1'>]",
            backgroundColor: Colors.black.toHex(),
          )
        ]);

    var helperEntityKeyNotFound = HelperEntity(
        id: "myhelperid",
        name: "my helper name",
        type: HelperType.ANCHORED_OVERLAYED_HELPER,
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        priority: 1,
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
        ]);

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
          helperEntity: helperEntity);
      await tester.pump(Duration(milliseconds: 100));
      var presenterFinder =
          find.byKey(ValueKey("EditorAnchoredFullscreenHelperPage"));
      expect(presenterFinder, findsOneWidget);
      presenter = (presenterFinder.evaluate().first.widget
              as PresenterInherited<EditorAnchoredFullscreenPresenter,
                  AnchoredFullscreenHelperViewModel>)
          .presenter;
      await tester.pump(Duration(milliseconds: 100));
    }

    testWidgets(
        'anchor key is found => anchored helper is created directly on step 2, no tutorial message',
        (WidgetTester tester) async {
      await beforeEach(tester, helperEntity);
      await tester.pump();
      await tester.pump();
      // expect to find only our helper type editor
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
      // action bar is visible only on step 2
      expect(find.byType(EditorActionBar), findsOneWidget);
      expect(find.byType(EditorTutorialOverlay), findsNothing);
    });

    testWidgets(
        'anchor key is not found => editor stays on step 1 with an error',
        (WidgetTester tester) async {
      await beforeEach(tester, helperEntityKeyNotFound);
      await tester.pump();
      await tester.pump();
      // expect to find only our helper type editor
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
      // action bar is visible only on step 2
      expect(find.byType(EditorActionBar), findsNothing);
    });

    testWidgets(
        'anchor key is found => all texts are correctly set, background color is correct',
        (WidgetTester tester) async {
      await beforeEach(tester, helperEntity);
      await tester.pump();
      await tester.pump();
      helperEntity.helperTexts.forEach((element) {
        dynamic textWidget =
            find.text(element.value).evaluate().first.widget;
        expect(textWidget, isNotNull);
        expect((textWidget.style.color as Color).toHex(), element.fontColor);
        expect(textWidget.style.fontWeight,
            FontWeightMapper.toFontWeight(element.fontWeight));
        expect(textWidget.style.fontFamily, contains(element.fontFamily));
        expect(textWidget.style.fontSize, element.fontSize);
      });
      expect(presenter.viewModel.backgroundBox.backgroundColor,
          equals(Colors.black));
      expect(presenter.viewModel.anchorValidated, isTrue);
    });
  });
}
