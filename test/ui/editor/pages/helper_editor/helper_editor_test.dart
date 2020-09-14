import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/router.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_anchored_helper/editor_anchored_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:palplugin/src/ui/editor/widgets/modal_bottomsheet_options.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';
import '../../../screen_tester_utilities.dart';

class HelperServiceMock extends Mock implements HelperService {}

class HelperEditorLoaderMock extends Mock implements HelperEditorLoader {}

Future _initPage(
  WidgetTester tester,
) async {
  HelperService helperService = HelperServiceMock();
  HelperEditorLoader loader = HelperEditorLoaderMock();

  var app = new MediaQuery(
      data: MediaQueryData(),
      child: PalTheme(
        theme: PalThemeData.light(),
        child: Builder(
          builder: (context) => MaterialApp(
            theme: PalTheme.of(context).buildTheme(),
            onGenerateRoute: (_) => MaterialPageRoute(
                builder: HelperEditorPageBuilder(
              HelperEditorPageArguments(null, ''),
              loader: loader,
              helperService: helperService,
            ).build),
          ),
        ),
      ));
  await tester.pumpWidget(app);
}

void main() {
  group('Editor', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _initPage(tester);
      // page exists
      expect(find.byKey(ValueKey("EditorPage")), findsOneWidget);
      // has a add button to add helper box, validate and cancel
      var editButtonFinder = find.byType(EditorButton);
      expect(editButtonFinder, findsNWidgets(2));
    });

    testWidgets('click on add helper button should show helpers list options',
        (WidgetTester tester) async {
      await _initPage(tester);
      var editButtonFinder = find.byKey(ValueKey("editModeButton"));
      // click on button
      await tester.tap(editButtonFinder);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      // shows options
      var helpersOptionsFinder = find.byType(ModalBottomSheetOptions);
      expect(helpersOptionsFinder, findsOneWidget);
      // check options
      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.byKey(ValueKey("cancel")), findsOneWidget);
      expect(find.byKey(ValueKey("validate")), findsOneWidget);
    });

    testWidgets(
        'Select an option make it highlithed with floating card explanation',
        (WidgetTester tester) async {
      await _initPage(tester);
      var editButtonFinder = find.byKey(ValueKey("editModeButton"));
      // click on button
      await tester.tap(editButtonFinder);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      var option1 = find.byKey(ValueKey("option0"));
      await tester.tap(option1.first);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
    });

    group('fullscreen helper', () {
      _addFullScreenWidget(WidgetTester tester) async {
        var editButtonFinder = find.byKey(ValueKey("editModeButton"));
        // click on button
        await tester.tap(editButtonFinder);
        await tester.pump();
        await tester.pumpAndSettle(Duration(milliseconds: 500));
        var option2 = find.byKey(ValueKey("option1"));
        await tester.tap(option2.first);
        await tester.pump();
        await tester.pumpAndSettle(Duration(milliseconds: 500));
        var validateButton = find.byKey(ValueKey("validate"));
        await tester.tap(validateButton.first);
        await tester.pumpAndSettle(Duration(milliseconds: 1000));
      }

      testWidgets('can add a fullscreen helper', (WidgetTester tester) async {
        await _initPage(tester);
        await _addFullScreenWidget(tester);
        expect(find.byType(ModalBottomSheetOptions), findsNothing);
        expect(find.byType(EditorFullScreenHelperPage), findsOneWidget);
      });

      testWidgets('can edit fullscreen title', (WidgetTester tester) async {
        await _initPage(tester);
        await _addFullScreenWidget(tester);
        expect(find.text('Edit me!'), findsOneWidget);
        var titleField = find.byKey(ValueKey('palFullscreenHelperTitleField'));
        await tester.tap(titleField.first);
        await tester.pump();
        await tester.enterText(titleField, 'Bonjour!');
        expect(find.text('Bonjour!'), findsOneWidget);
      });

      testWidgets('can save helper', (WidgetTester tester) async {
        await _initPage(tester);
        await _addFullScreenWidget(tester);
        expect(find.text('Edit me!'), findsOneWidget);
        var titleField = find.byKey(ValueKey('palFullscreenHelperTitleField'));
        await tester.tap(titleField.first);
        await tester.pump();
        await tester.enterText(titleField, 'Bonjour!');
        expect(find.text('Bonjour!'), findsOneWidget);

        // TODO: Add validate button tap
      });
    });
  });

  group('anchored helper', () {

    final _navigatorKey = GlobalKey<NavigatorState>();

    ElementFinder _elementFinder;

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

    Future _initAppWithPal(WidgetTester tester,) async {
      BuildContext context;
      Pal app = Pal(
        appToken: "testtoken",
        editorModeEnabled: true,
        child: new MaterialApp(
          onGenerateRoute: (_) => MaterialPageRoute(builder: (ctx) {
            context = ctx;
            return _myHomeTest;
          }),
          navigatorKey: _navigatorKey,
          navigatorObservers: [PalNavigatorObserver.instance()],
        ),
      );
      await tester.pumpWidget(app);
      expect(find.text("text1"), findsOneWidget);
      expect(find.text("text2"), findsOneWidget);
      expect(find.text("tapme"), findsOneWidget);
    }

    _showEditor(WidgetTester tester) async {
      // push helper editor page
      HelperEditorPageArguments args = HelperEditorPageArguments(
        _navigatorKey,
        "widget.pageId",
        helperName: "helper name",
        triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      );
      _elementFinder = ElementFinder(_navigatorKey.currentContext);
      showOverlayed(
        _navigatorKey,
        HelperEditorPageBuilder(args, elementFinder: _elementFinder).build,
      );
      await tester.pumpAndSettle(Duration(seconds: 1));
    }

    _addAnchoredScreenWidget(WidgetTester tester) async {
      var editButtonFinder = find.byKey(ValueKey("editModeButton"));
      // click on button
      await tester.tap(editButtonFinder);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      var option3 = find.byKey(ValueKey("option2"));
      await tester.tap(option3.first);
      await tester.pump();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      var validateButton = find.byKey(ValueKey("validate"));
      await tester.tap(validateButton.first);
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
    }

    testWidgets('can add an anchored fullscreen helper', (WidgetTester tester) async {
      await _initAppWithPal(tester);
      await _showEditor(tester);
      await _addAnchoredScreenWidget(tester);
      expect(find.byType(ModalBottomSheetOptions), findsNothing);
      expect(find.byType(EditorAnchoredFullscreenHelper), findsOneWidget);
    });

    testWidgets('shows one container with borders for each element of user app page', (WidgetTester tester) async {
      await tester.setIphone11Max();
      await _initAppWithPal(tester);
      await _showEditor(tester);
      await _addAnchoredScreenWidget(tester);
      var refreshFinder = find.byKey(ValueKey("refreshButton"));
      expect(refreshFinder, findsOneWidget);
      // await tester.tap(refreshFinder);
      expect(find.byKey(ValueKey("elementContainer")), findsWidgets);
    });

  });
}
