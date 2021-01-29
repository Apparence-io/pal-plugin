import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_update_helper/editor_update_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_textfield.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_action_bar/widgets/editor_action_item.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/color_picker/color_picker.dart';
import 'package:pal/src/ui/editor/widgets/bubble_overlay.dart';
import 'package:pal/src/ui/editor/widgets/edit_helper_toolbar.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';
import '../../../../../pal_test_utilities.dart';

class HelperEditorServiceMock extends Mock implements EditorHelperService {}

class PalEditModeStateServiceMock extends Mock
    implements PalEditModeStateService {}

class PackageVersionReaderMock extends Mock implements PackageVersionReader {}

void main() {
  group('[Editor] create - Update helper', () {
    var packageVersionReaderService = PackageVersionReaderMock();

    when(packageVersionReaderService.init()).thenAnswer((_) => Future.value());
    when(packageVersionReaderService.version).thenReturn('0.0.1');

    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorUpdateHelperPresenter presenter;

    EditorHelperService helperEditorServiceMock = HelperEditorServiceMock();

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

      reset(helperEditorServiceMock);
      await initAppWithPal(tester, null, _navigatorKey,
          routeFactory: routeFactory);
      await pumpHelperWidget(
        tester,
        _navigatorKey,
        HelperTriggerType.ON_SCREEN_VISIT,
        HelperType.UPDATE_HELPER,
        HelperTheme.BLACK,
        editorHelperService: helperEditorServiceMock,
        palEditModeStateService: PalEditModeStateServiceMock(),
        packageVersionReader: packageVersionReaderService,
      );
      var presenterFinder =
          find.byKey(ValueKey("pal_EditorUpdateHelperWidget_Builder"));
      var page = presenterFinder.evaluate().first.widget as PresenterInherited<
          EditorUpdateHelperPresenter, UpdateHelperViewModel>;
      presenter = page.presenter;
    }

    // ------------------------------------------------
    // TESTS SUITE
    // ------------------------------------------------

    testWidgets('should create', (WidgetTester tester) async {
      await beforeEach(tester);
      expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
    });

    testWidgets('on text press  => button is disabled',
        (WidgetTester tester) async {
      await beforeEach(tester);
      expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
      var textMode = find.byKey(ValueKey('editableActionBarTextButton'));
      await tester.tap(textMode);
      await tester.pumpAndSettle();
    });

    testWidgets('on settings press  => button is disabled',
        (WidgetTester tester) async {
      await beforeEach(tester);
      expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
      var textMode = find.byKey(ValueKey('editableActionBarSettingsButton'));
      await tester.tap(textMode);
      await tester.pumpAndSettle();
    });

    Future _fillFields(WidgetTester tester, String firstField,
        String secondField, String thirdField) async {
      // INIT TEXTFIELDS
      var editableTextsFinder = find.byType(TextField);
      await enterTextInEditable(tester, 0, firstField);
      await enterTextInEditable(tester, 1, secondField);
      await tester.pump();

      // add new changelog line
      (tester.widget(
                  find.byKey(ValueKey('pal_EditorUpdateHelperWidget_AddNote')))
              as CircleIconButton)
          .onTapCallback();
      // await tester.tap(addChangelogButtonFinder);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      var editableFinder = find.byType(TextField);
      await enterTextInEditable(tester, 1, thirdField);
      await tester.pump();
      // INIT TEXTFIELDS
    }

    testWidgets('on preview press  => show update client preview & cancel',
        (WidgetTester tester) async {
      await beforeEach(tester);

      final String firstField = 'test title edited';
      final String secondField = 'test button edited';
      final String thirdField = 'test changelog edited';
      await _fillFields(tester, firstField, secondField, thirdField);

      final previewButtonFinder =
          find.byKey(ValueKey('editableActionBarPreviewButton'));
      final previewButton =
          previewButtonFinder.evaluate().first.widget as EditorActionItem;
      previewButton.onTap();
      await tester.pumpAndSettle();

      await tester.pump(Duration(milliseconds: 1100));
      await tester.pump(Duration(milliseconds: 5000));
      await tester.pump(Duration(milliseconds: 700));
      await tester.pump(Duration(milliseconds: 700));
      expect(find.byKey(ValueKey('EditorPreviewPage_Builder')), findsOneWidget);

      Finder titleFinder =
          find.byKey(ValueKey('pal_UserUpdateHelperWidget_AppSummary_Title'));
      expect(titleFinder, findsOneWidget);
      Text titleText = tester.widget(titleFinder);
      expect(titleText.data, equals('test title edited'));

      Finder thanksFinder =
          find.byKey(ValueKey('pal_UserUpdateHelperWidget_ThanksButton_Label'));
      expect(thanksFinder, findsOneWidget);
      Text thanksText = tester.widget(thanksFinder);
      expect(thanksText.data, equals('test button edited'));

      Finder changelogFinder = find
          .byKey(ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_0'));
      expect(changelogFinder, findsOneWidget);
      RichText changeLogText = tester.widget(changelogFinder);
      expect((changeLogText.text.children.last as TextSpan).text,
          equals('test changelog edited'));

      (tester.widget(find.byKey(
                  ValueKey('pal_UserUpdateHelperWidget_ThanksButton_Raised')))
              as RaisedButton)
          .onPressed();
      await tester.pumpAndSettle();

      await tester.pump(Duration(milliseconds: 700));
      await tester.pump(Duration(milliseconds: 700));
      await tester.pump(Duration(milliseconds: 5000));
      await tester.pump(Duration(milliseconds: 1100));

      expect(find.byKey(ValueKey('EditorPreviewPage_Builder')), findsNothing);
    });

    testWidgets(
        'close editor, pal bubble is hidden  => page is removed, pal bubble is visible',
        (WidgetTester tester) async {
      await beforeEach(tester);

      var cancelFinder = find.byKey(ValueKey('editableActionBarCancelButton'));
      await tester.tap(cancelFinder);
      await tester.pumpAndSettle();
      expect(find.byType(BubbleOverlayButton), findsOneWidget);
      // var bubbleWidget = find.byType(BubbleOverlayButton).evaluate().first.widget as BubbleOverlayButton;
      // expect(bubbleWidget.visibility.value, isTrue);
    });

    testWidgets('title not empty, 0 changelog  => save button is disabled',
        (WidgetTester tester) async {
      await beforeEach(tester);
      var cancelFinder = find.byKey(ValueKey('editableActionBarCancelButton'));
      var validateFinder =
          find.byKey(ValueKey('editableActionBarValidateButton'));
      expect(cancelFinder, findsOneWidget);
      expect(validateFinder, findsOneWidget);
      var validateButton =
          validateFinder.evaluate().first.widget as CircleIconButton;
      expect(validateButton.onTapCallback, isNull);
    });

    testWidgets(
        'title not empty, 1 changelog with text  => save button is enabled',
        (WidgetTester tester) async {
      await beforeEach(tester);
      var addChangelogButtonFinder =
          find.byKey(ValueKey('pal_EditorUpdateHelperWidget_AddNote'));
      await tester.tap(addChangelogButtonFinder);
      var editableFinder = find.byType(TextField);
      await enterTextInEditable(tester, 1, 'Lorem ipsum');
      await enterTextInEditable(
          tester, 1, 'Lorem ipsum changelog');

      var validateFinder =
          find.byKey(ValueKey('editableActionBarValidateButton'));
      var validateButton =
          validateFinder.evaluate().first.widget as CircleIconButton;
      expect(validateButton.onTapCallback, isNotNull);
      expect(presenter.viewModel.titleTextForm.text, 'Lorem ipsum');
      expect(presenter.viewModel.changelogsTextsForm['0'].text,
          'Lorem ipsum changelog');
      await tester.pump(Duration(milliseconds: 100));
    });

    testWidgets('click on + button => add one changelog line',
        (WidgetTester tester) async {
      await beforeEach(tester);
      // 2 text because title and button has text
      expect(find.byType(TextField), findsNWidgets(2));
      // add new changelog line
      var addChangelogButtonFinder =
          find.byKey(ValueKey('pal_EditorUpdateHelperWidget_AddNote'));
      await tester.tap(addChangelogButtonFinder);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      // 3 text =>  title, button and new changelog
      expect(find.byType(TextField), findsNWidgets(3));
    });

    testWidgets(
        'set title = "lorem ipsum", add 2 changelog => save call HelperService.saveUpdateHelper',
        (WidgetTester tester) async {
      await beforeEach(tester);
      expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
      var addChangelogButtonFinder =
          find.byKey(ValueKey('pal_EditorUpdateHelperWidget_AddNote'));
      await tester.tap(addChangelogButtonFinder);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      var editableFinder = find.byType(TextField);
      await enterTextInEditable(tester, 1, 'Lorem ipsum');
      await enterTextInEditable(
          tester, 1, 'Lorem ipsum changelog');

      var validateFinder =
          find.byKey(ValueKey('editableActionBarValidateButton'));
      var validateButton =
          validateFinder.evaluate().first.widget as CircleIconButton;
      validateButton.onTapCallback();
      await tester.pump(Duration(seconds: 1));
      verify(helperEditorServiceMock.saveUpdateHelper(any)).called(1);
      await tester.pump(Duration(seconds: 2));
      await tester.pump(Duration(milliseconds: 100));
    });

    testWidgets('base color is blue => change background color',
        (WidgetTester tester) async {
      await beforeEach(tester);
      expect(
        presenter.viewModel.backgroundBoxForm.backgroundColor.value,
        Colors.blueAccent,
      );

      var colorPickerButton = find.byKey(
          ValueKey('pal_EditorUpdateHelperWidget_BackgroundColorPicker'));
      await tester.tap(colorPickerButton);
      await tester.pumpAndSettle();
      expect(find.byType(ColorPickerDialog), findsOneWidget);

      var hecColorField =
          find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
      await tester.enterText(hecColorField, '#FFFFFF');
      var editableFinder = find.byType(TextField);
      await enterTextInEditable(tester, 1, 'Lorem ipsum');

      var validateColorButton =
          find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'));
      await tester.tap(validateColorButton);
      await tester.pumpAndSettle();

      expect(presenter.viewModel.backgroundBoxForm.backgroundColor.value,
          Color(0xFFFFFFFF));
    });

    testWidgets('change thank button text => viewmodel has been updated',
        (WidgetTester tester) async {
      await beforeEach(tester);
      var titleTextField = find
          .byKey(ValueKey('pal_EditorUpdateHelperWidget_ThanksButtonField'));
      await tester.enterText(titleTextField, 'Thanks my friend!');
      await tester.pumpAndSettle();
      expect(find.text('Thanks my friend!'), findsOneWidget);
      expect(presenter.viewModel.positivButtonForm.text, 'Thanks my friend!');
    });

    testWidgets(
        'tap on on field, tap on a second field => only one toolbar is shown',
        (WidgetTester tester) async {
      await beforeEach(tester);
      var textFinder = find.byType(EditableTextField);
      var text1 = textFinder.evaluate().first.widget as EditableTextField;
      var text2 =
          textFinder.evaluate().elementAt(1).widget as EditableTextField;
      expect(find.byType(EditHelperToolbar), findsNothing);
      // add new changelog line
      var addChangelogButtonFinder =
          find.byKey(ValueKey('pal_EditorUpdateHelperWidget_AddNote'));
      await tester.tap(addChangelogButtonFinder);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      expect(textFinder, findsNWidgets(3));

      await tester.tap(find.byType(EditableTextField).first);
      await tester.pump(Duration(seconds: 1));
      expect(find.byType(EditHelperToolbar), findsOneWidget);

      // text2.toolbarVisibility.value = true;
      await tester.pump(Duration(seconds: 1));
      expect(find.byType(EditHelperToolbar), findsOneWidget);
    });

    test('HelperViewModel => transform to FullscreenHelperViewModel ', () {
      HelperViewModel helperViewModel = HelperViewModel(
        id: "testid",
        name: "test",
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
        helperType: HelperType.UPDATE_HELPER,
        helperTheme: HelperTheme.BLACK,
        priority: 1,
        minVersionCode: "0.0.0",
        maxVersionCode: "1.0.1",
      );
      var helper = UpdateHelperViewModel.fromHelperViewModel(helperViewModel);
      expect(helper.id, helperViewModel.id);
      expect(helper.name, helperViewModel.name);
      expect(helper.minVersionCode, helperViewModel.minVersionCode);
      expect(helper.maxVersionCode, helperViewModel.maxVersionCode);
      expect(helper.triggerType, HelperTriggerType.ON_SCREEN_VISIT);
      expect(helper.helperTheme, HelperTheme.BLACK);
    });
  });

  group('[Editor] update -  Update helper', () {
    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorUpdateHelperPresenter presenter;

    EditorHelperService helperEditorServiceMock = HelperEditorServiceMock();

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
    Future beforeEach(WidgetTester tester, HelperEntity helperEntity) async {
      reset(helperEditorServiceMock);
      await initAppWithPal(tester, _myHomeTest, _navigatorKey);
      await pumpHelperWidget(
          tester,
          _navigatorKey,
          HelperTriggerType.ON_SCREEN_VISIT,
          HelperType.UPDATE_HELPER,
          HelperTheme.BLACK,
          helperEntity: helperEntity,
          editorHelperService: helperEditorServiceMock);
      var presenterFinder =
          find.byKey(ValueKey("pal_EditorUpdateHelperWidget_Builder"));
      var page = presenterFinder.evaluate().first.widget as PresenterInherited<
          EditorUpdateHelperPresenter, UpdateHelperViewModel>;
      presenter = page.presenter;
    }

    HelperEntity validUpdateHelperEntity() => HelperEntity(
            name: "my helper entity",
            type: HelperType.UPDATE_HELPER,
            triggerType: HelperTriggerType.ON_SCREEN_VISIT,
            priority: 1,
            versionMinId: 25,
            versionMaxId: 25,
            helperTexts: [
              HelperTextEntity(
                value: "title",
                fontColor: "#FF001100",
                fontWeight: "w100",
                fontSize: 17,
                fontFamily: "Montserrat",
                key: UpdatescreenHelperKeys.TITLE_KEY,
              ),
              HelperTextEntity(
                value: "changelog 1",
                fontColor: "#FF001100",
                fontWeight: "w100",
                fontSize: 17,
                fontFamily: "Montserrat",
                key: "${UpdatescreenHelperKeys.LINES_KEY}:0",
              ),
              HelperTextEntity(
                value: "changelog 2",
                fontColor: "#FF001100",
                fontWeight: "w100",
                fontSize: 17,
                fontFamily: "Montserrat",
                key: "${UpdatescreenHelperKeys.LINES_KEY}:1",
              ),
            ],
            helperImages: [
              HelperImageEntity(
                url: "http://testurl.com",
                key: FullscreenHelperKeys.IMAGE_KEY,
              )
            ],
            helperBoxes: [
              HelperBoxEntity(
                key: FullscreenHelperKeys.BACKGROUND_KEY,
                backgroundColor: "#FF001100",
              )
            ]);

    testWidgets(
        'Valid helper entity, 2 changelog, 1 title => should create in edit mode all attributes',
        (WidgetTester tester) async {
      var entity = validUpdateHelperEntity();
      await beforeEach(tester, entity);
      expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
      expect(presenter.viewModel.changelogsTextsForm.length, 2);
      entity.helperTexts.forEach(
          (element) => expect(find.text(element.value), findsOneWidget));
    });
  });
}
