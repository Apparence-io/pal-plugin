import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper_presenter.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:pal/src/ui/editor/widgets/editable_textfield.dart';
import '../../../pal_test_utilities.dart';

void main() {
  group('[Editor] Update helper', () {

    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorUpdateHelperPresenter presenter;

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
        HelperType.UPDATE_HELPER,
        HelperTheme.BLACK,
      );
      var presenterFinder =
          find.byKey(ValueKey("pal_EditorUpdateHelperWidget_Builder"));
      var page = presenterFinder.evaluate().first.widget
          as PresenterInherited<EditorUpdateHelperPresenter, UpdateHelperViewModel>;
      presenter = page.presenter;
    }

    _enterTextInEditable(WidgetTester tester, Finder finder, String text) async{
      await tester.tap(finder);
      await tester.pump();
      await tester.enterText(finder, text);
    }

    // ------------------------------------------------
    // TESTS SUITE
    // ------------------------------------------------

    testWidgets('should create', (WidgetTester tester) async {
      await beforeEach(tester);
      expect(find.byType(EditorUpdateHelperPage), findsOneWidget);
    });

    testWidgets('title not empty, 0 changelog  => save button is disabled', (WidgetTester tester) async {
      await beforeEach(tester);
      var cancelFinder = find.byKey(ValueKey('editModeCancel'));
      var validateFinder = find.byKey(ValueKey('editModeValidate'));
      expect(cancelFinder, findsOneWidget);
      expect(validateFinder, findsOneWidget);
      var validateButton = validateFinder.evaluate().first.widget as EditorButton;
      expect(validateButton.isEnabled, isFalse);
    });

    testWidgets('title not empty, 1 changelog with text  => save button is enabled', (WidgetTester tester) async {
      await beforeEach(tester);
      var addChangelogButtonFinder = find.byKey(ValueKey('pal_EditorUpdateHelperWidget_AddNote'));
      await tester.tap(addChangelogButtonFinder);
      var editableFinder = find.byType(TextField);
      await _enterTextInEditable(tester, editableFinder.first, 'Lorem ipsum');
      await _enterTextInEditable(tester, editableFinder.at(1), 'Lorem ipsum changelog');

      var validateFinder = find.byKey(ValueKey('editModeValidate'));
      var validateButton = validateFinder.evaluate().first.widget as EditorButton;
      expect(validateButton.isEnabled, isTrue);
      expect(presenter.viewModel.titleField.text.value, 'Lorem ipsum');
      presenter.viewModel.changelogsFields.forEach((key, value) {
        print("$key => ${value.text.value ?? 'no value'}");
      });
      expect(presenter.viewModel.changelogsFields['0'].text.value, 'Lorem ipsum changelog');
    });

    testWidgets('click on + button => add one changelog line', (WidgetTester tester) async {
      await beforeEach(tester);
      // 2 text because title and button has text
      expect(find.byType(TextField), findsNWidgets(2));
      // add new changelog line
      var addChangelogButtonFinder = find.byKey(ValueKey('pal_EditorUpdateHelperWidget_AddNote'));
      await tester.tap(addChangelogButtonFinder);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      // 3 text =>  title, button and new changelog
      expect(find.byType(TextField), findsNWidgets(3));
      var editableTextsFinder = find.byType(TextField);
    });

    testWidgets('set title = "lorem ipsum", add 2 changelog => save call HelperService.saveUpdateHelper', (WidgetTester tester) async {
      await beforeEach(tester);
      expect(find.byType(EditorUpdateHelperPage), findsOneWidget);

    });


    // testWidgets('should change background color', (WidgetTester tester) async {
    //   await beforeEach(tester);
    //
    //   expect(
    //     presenter.viewModel.bodyBox.backgroundColor.value,
    //     Colors.blueAccent,
    //   );
    //
    //   var colorPickerButton = find.byKey(
    //       ValueKey('pal_EditorUpdateHelperWidget_BackgroundColorPicker'));
    //   await tester.tap(colorPickerButton);
    //   await tester.pumpAndSettle();
    //
    //   expect(find.byType(ColorPickerDialog), findsOneWidget);
    //
    //   var hecColorField =
    //       find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
    //   await tester.enterText(hecColorField, '#FFFFFF');
    //   await tester.pumpAndSettle();
    //
    //   var validateColorButton =
    //       find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'));
    //   await tester.tap(validateColorButton);
    //   await tester.pumpAndSettle();
    //
    //   expect(
    //     presenter.viewModel.bodyBox.backgroundColor.value,
    //     Color(0xFFFFFFFF),
    //   );
    // });
    //
    // testWidgets('should change title', (WidgetTester tester) async {
    //   await beforeEach(tester);
    //
    //   var titleTextField =
    //       find.byKey(ValueKey('pal_EditorUpdateHelperWidget_TitleField'));
    //   await tester.enterText(titleTextField, 'My awesome title!');
    //   await tester.pumpAndSettle();
    //   expect(find.text('My awesome title!'), findsOneWidget);
    //   expect(presenter.viewModel.titleField.text.value,
    //       'My awesome title!');
    // });
    //
    // testWidgets('should change thanks button', (WidgetTester tester) async {
    //   await beforeEach(tester);
    //
    //   var titleTextField = find
    //       .byKey(ValueKey('pal_EditorUpdateHelperWidget_ThanksButtonField'));
    //   await tester.enterText(titleTextField, 'Thanks my friend!');
    //   await tester.pumpAndSettle();
    //   expect(find.text('Thanks my friend!'), findsOneWidget);
    //   expect(presenter.viewModel.thanksButton.text.value,
    //       'Thanks my friend!');
    // });
    //
    // testWidgets('should add changelogs fields', (WidgetTester tester) async {
    //   await beforeEach(tester);
    //   expect(presenter.viewModel.changelogsFields.length, 1);
    //   expect(find.byType(EditableTextField), findsNWidgets(3));
    //   expect(find.text('Enter your first update line here...'), findsOneWidget);
    //   expect(find.text('Enter update line here...'), findsNothing);
    //
    //   presenter.addChangelogNote();
    //   await tester.pump();
    //   await tester.pumpAndSettle(Duration(milliseconds: 500));
    //   expect(presenter.viewModel.changelogsFields.length, 2);
    //
    //   presenter.addChangelogNote();
    //   await tester.pump();
    //   await tester.pumpAndSettle(Duration(milliseconds: 500));
    //   expect(presenter.viewModel.changelogsFields.length, 3);
    //
    //   presenter.addChangelogNote();
    //   await tester.pump();
    //   await tester.pumpAndSettle(Duration(milliseconds: 500));
    //   expect(presenter.viewModel.changelogsFields.length, 4);
    //
    //   expect(find.byType(EditableTextField), findsNWidgets(6));
    //   expect(find.text('Enter your first update line here...'), findsOneWidget);
    //   expect(find.text('Enter update line here...'), findsNWidgets(3));
    // });
    //
    // testWidgets('should change note', (WidgetTester tester) async {
    //   await beforeEach(tester);
    //   presenter.addChangelogNote();
    //   await tester.pump();
    //   await tester.pumpAndSettle();
    //
    //   var textField = find.byType(EditableTextField);
    //   await tester.enterText(textField.at(2), 'A note');
    //   await tester.pumpAndSettle();
    //   expect(find.text('A note'), findsOneWidget);
    //
    //   expect(presenter.viewModel.changelogsFields['1'].text.value, 'A note');
    // });
    //
    // testWidgets('should edit media', (WidgetTester tester) async {
    //   await beforeEach(tester);
    //
    //   expect(
    //       find.byKey(ValueKey(
    //           'pal_EditorUpdateHelperWidget_EditableMedia_EditButton')),
    //       findsOneWidget);
    // });
  });
}
