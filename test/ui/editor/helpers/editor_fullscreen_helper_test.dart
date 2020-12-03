import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';
import '../../../pal_test_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HelperEditorServiceMock extends Mock implements EditorHelperService {}

void main() {

  group('[Editor] Fullscreen helper - creation mode', () {

    EditorFullScreenHelperPresenter presenter;

    HelperEditorServiceMock helperEditorServiceMock = HelperEditorServiceMock();

    Future _beforeEach(WidgetTester tester) async {
      reset(helperEditorServiceMock);
      EditorFullScreenHelperPage editor = EditorFullScreenHelperPage.create(
        parameters: HelperEditorPageArguments(
          null,
          "pageId_IEPZE",
          helperMinVersion: "1.0.1",
          helperMaxVersion: null
        ) ,
        helperService: helperEditorServiceMock,
        helperViewModel: HelperViewModel(
          name: "my helper",
          helperType: HelperType.HELPER_FULL_SCREEN,
          helperTheme: HelperTheme.BLACK,
          triggerType: HelperTriggerType.ON_SCREEN_VISIT
        )
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

    _enterTextInEditable(WidgetTester tester, Finder finder, String text) async{
      await tester.tap(finder);
      await tester.pump();
      await tester.enterText(finder, text);
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

  });
}
