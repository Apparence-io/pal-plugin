import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_presenter.dart';
import 'package:pal/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:pal/src/ui/editor/widgets/edit_helper_toolbar.dart';
import '../../../pal_test_utilities.dart';

class HelperEditorServiceMock extends Mock implements EditorHelperService {}

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
      await initAppWithPal(tester, _myHomeTest, _navigatorKey);
      await pumpHelperWidget(
        tester, _navigatorKey,
        HelperTriggerType.ON_SCREEN_VISIT,
        HelperType.SIMPLE_HELPER,
        HelperTheme.BLACK,
        editorHelperService: helperEditorServiceMock
      );
      var presenterFinder = find.byKey(ValueKey("palEditorSimpleHelperWidgetBuilder"));
      var page = presenterFinder.evaluate().first.widget
        as PresenterInherited<EditorSimpleHelperPresenter, SimpleHelperViewModel>;
      presenter = page.presenter;
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
    }

    _enterTextInEditable(WidgetTester tester, Finder finder, String text) async{
      await tester.tap(finder);
      await tester.pump();
      await tester.enterText(finder, text);
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

    testWidgets('text is empty => cancel, validate buttons exists, validate button is disabled', (WidgetTester tester) async {
      await _beforeEach(tester);
      var editableTextsFinder = find.byType(TextField);
      await _enterTextInEditable(tester, editableTextsFinder.at(0), '');
      await tester.pumpAndSettle();
      expect(presenter.viewModel.detailsField.text.value, equals(''));

      var cancelFinder = find.byKey(ValueKey('editModeCancel'));
      var validateFinder = find.byKey(ValueKey('editModeValidate'));
      expect(cancelFinder, findsOneWidget);
      expect(validateFinder, findsOneWidget);
      var validateButton = validateFinder.evaluate().first.widget as EditorButton;
      expect(validateButton.isEnabled, isFalse);
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
      await _enterTextInEditable(tester, editableTextsFinder.at(0), 'my helper tips lorem');
      await tester.pumpAndSettle();
      var validateFinder = find.byKey(ValueKey('editModeValidate'));
      var validateButton = validateFinder.evaluate().first.widget as EditorButton;
      expect(validateButton.isEnabled, isTrue);

      validateButton.onPressed();
      await tester.pump(Duration(seconds: 1));
      verify(helperEditorServiceMock.saveSimpleHelper(any, any)).called(1);
      await tester.pump(Duration(seconds: 2));
      await tester.pump(Duration(milliseconds: 100));
    });



  });

}
