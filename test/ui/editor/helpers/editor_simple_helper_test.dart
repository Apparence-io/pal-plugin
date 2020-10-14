import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_theme.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/edit_helper_toolbar.dart';
import '../../../pal_test_utilities.dart';

void main() {
  group('[Editor] Simple helper', () {
    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorSimpleHelperPresenter presenter;

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
    Future _beforeEach(WidgetTester tester) async {
      await initAppWithPal(tester, _myHomeTest, _navigatorKey);
      await pumpHelperWidget(
        tester,
        _navigatorKey,
        HelperTriggerType.ON_SCREEN_VISIT,
        HelperType.SIMPLE_HELPER,
        HelperTheme.BLACK,
      );
      var presenterFinder =
          find.byKey(ValueKey("palEditorSimpleHelperWidgetBuilder"));
      var page = presenterFinder.evaluate().first.widget as PresenterInherited<
          EditorSimpleHelperPresenter, EditorSimpleHelperModel>;
      presenter = page.presenter;
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
    }

    testWidgets('should textfield be present', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Edit me!'), findsOneWidget);
    });

    testWidgets('should close toolbar', (WidgetTester tester) async {
      await _beforeEach(tester);

      var simpleHelperDetailTextField =
          find.byKey(ValueKey('palSimpleHelperDetailField'));
      await tester.tap(simpleHelperDetailTextField);
      await tester.pumpAndSettle();

      expect(find.byType(EditHelperToolbar), findsOneWidget);

      var closeButtonToolbar =
          find.byKey(ValueKey('pal_EditHelperToolbar_Close'));
      await tester.tap(closeButtonToolbar);
      await tester.pumpAndSettle();

      expect(find.byType(EditHelperToolbar), findsNothing);
    });

    testWidgets('should enter text', (WidgetTester tester) async {
      await _beforeEach(tester);

      var simpleHelperDetailTextField =
          find.byKey(ValueKey('palSimpleHelperDetailField'));
      await tester.enterText(simpleHelperDetailTextField, 'Hello!');
      await tester.pumpAndSettle();
      expect(find.text('Hello!'), findsOneWidget);
    });
  });
}
