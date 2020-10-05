import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_theme.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/alert_dialogs/color_picker.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_textfield.dart';
import '../../../pal_test_utilities.dart';

void main() {
  group('[Editor] Update helper', () {
    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorUpdateHelperPresenter presenter;

    Scaffold _myHomeTest = Scaffold(
      body: Column(
        children: [
          Text(
            "text1",
            key: ValueKey("text1"),
          ),
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
      var page = presenterFinder.evaluate().first.widget as PresenterInherited<
          EditorUpdateHelperPresenter, EditorUpdateHelperModel>;
      presenter = page.presenter;
    }

    testWidgets('should change background color', (WidgetTester tester) async {
      await beforeEach(tester);

      expect(presenter.updateHelperViewModel.backgroundColor.value,
          Color(0xFFBFEEF5));

      var colorPickerButton = find.byKey(
          ValueKey('pal_EditorUpdateHelperWidget_BackgroundColorPicker'));
      await tester.tap(colorPickerButton);
      await tester.pumpAndSettle();

      expect(find.byType(ColorPickerDialog), findsOneWidget);

      var hecColorField =
          find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
      await tester.enterText(hecColorField, '#FFFFFF');
      await tester.pumpAndSettle();

      var validateColorButton =
          find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'));
      await tester.tap(validateColorButton);
      await tester.pumpAndSettle();

      expect(presenter.updateHelperViewModel.backgroundColor.value,
          Color(0xFFFFFFFF));
    });

    testWidgets('should change title', (WidgetTester tester) async {
      await beforeEach(tester);

      var titleTextField =
          find.byKey(ValueKey('pal_EditorUpdateHelperWidget_TitleField'));
      await tester.enterText(titleTextField, 'My awesome title!');
      await tester.pumpAndSettle();
      expect(find.text('My awesome title!'), findsOneWidget);
      expect(presenter.updateHelperViewModel.titleField.text.value,
          'My awesome title!');
    });

    testWidgets('should change thanks button', (WidgetTester tester) async {
      await beforeEach(tester);

      var titleTextField = find
          .byKey(ValueKey('pal_EditorUpdateHelperWidget_ThanksButtonField'));
      await tester.enterText(titleTextField, 'Thanks my friend!');
      await tester.pumpAndSettle();
      expect(find.text('Thanks my friend!'), findsOneWidget);
      expect(presenter.updateHelperViewModel.thanksButton.text.value,
          'Thanks my friend!');
    });

    testWidgets('should add changelogs fields', (WidgetTester tester) async {
      await beforeEach(tester);
      expect(presenter.updateHelperViewModel.changelogsFields.length, 1);
      expect(find.byType(EditableTextField), findsNWidgets(3));
      expect(find.text('Enter your first update line here...'), findsOneWidget);
      expect(find.text('Enter update line here...'), findsNothing);

      presenter.addChangelogNote();
      await tester.pump();
      await tester.pumpAndSettle();
      expect(presenter.updateHelperViewModel.changelogsFields.length, 2);

      presenter.addChangelogNote();
      await tester.pump();
      await tester.pumpAndSettle();
      expect(presenter.updateHelperViewModel.changelogsFields.length, 3);

      presenter.addChangelogNote();
      await tester.pump();
      await tester.pumpAndSettle();
      expect(presenter.updateHelperViewModel.changelogsFields.length, 4);

      expect(find.byType(EditableTextField), findsNWidgets(6));
      expect(find.text('Enter your first update line here...'), findsOneWidget);
      expect(find.text('Enter update line here...'), findsNWidgets(3));
    });

    testWidgets('should change note', (WidgetTester tester) async {
      await beforeEach(tester);
      presenter.addChangelogNote();
      await tester.pump();
      await tester.pumpAndSettle();

      var textField = find.byType(EditableTextField);
      await tester.enterText(textField.at(2), 'A note');
      await tester.pumpAndSettle();
      expect(find.text('A note'), findsOneWidget);

      ValueKey changelogKey =
          ValueKey('pal_EditorUpdateHelperWidget_ReleaseNoteField_1');
      expect(
          presenter.updateHelperViewModel
              .changelogsFields[changelogKey.toString()].text.value,
          'A note');
    });
  });
}
