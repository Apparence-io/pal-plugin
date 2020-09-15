import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_anchored_helper/editor_anchored_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_anchored_helper/editor_anchored_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_anchored_helper/editor_anchored_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_presenter.dart';
import 'package:palplugin/src/ui/editor/widgets/modal_bottomsheet_options.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';
import '../../screen_tester_utilities.dart';
import '../../../pal_test_utilities.dart';

void main() {
  group('Anchored helper editor', () {

    final _navigatorKey = GlobalKey<NavigatorState>();

    ElementFinder _elementFinder;

    EditorAnchoredFullscreenPresenter presenter;

    EditorAnchoredFullscreenHelper component = EditorAnchoredFullscreenHelper();

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

    // init pal + go to editor
    Future beforeEach(WidgetTester tester) async {
      await initAppWithPal(tester, _myHomeTest, _navigatorKey);
      await showEditor(tester, _navigatorKey, HelperTriggerType.ON_SCREEN_VISIT);
      await addHelperEditorByType(tester, HelperType.ANCHORED_OVERLAYED_HELPER);
      var presenterFinder = await find.byKey(ValueKey("EditorAnchoredFullscreenHelperPage"));
      expect(presenterFinder, findsOneWidget);
      presenter = (presenterFinder.evaluate().first.widget as MVVMPage).presenter;
    }

    testWidgets('can add an anchored fullscreen helper', (WidgetTester tester) async {
      await beforeEach(tester);
      // expect to find only our helper type editor
      expect(find.byType(ModalBottomSheetOptions), findsNothing);
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
    });

    testWidgets('shows one container with borders for each element of user app page', (WidgetTester tester) async {
      await beforeEach(tester);
      var refreshFinder = find.byKey(ValueKey("refreshButton"));
      expect(refreshFinder, findsOneWidget);
      // await tester.tap(refreshFinder);
      expect(find.byKey(ValueKey("elementContainer")), findsWidgets);
    });

    testWidgets("tap on container's element select it as anchor", (WidgetTester tester) async {
      // init pal + go to editor
      await tester.setIphone11Max();
      await beforeEach(tester);
      // tap on first element
      var elementsFinder = find.byKey(ValueKey("elementContainer"));
      var element1 = elementsFinder.evaluate().elementAt(1).widget as InkWell;
      var element2 = elementsFinder.evaluate().elementAt(2).widget as InkWell;
      element1.onTap();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      // expect first element to be selected
      expect(presenter.viewModel.selectedAnchorKey, contains("text1"));
      // expect second element to be selected
      element2.onTap();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(presenter.viewModel.selectedAnchorKey, contains("text2"));
    });

  });
}