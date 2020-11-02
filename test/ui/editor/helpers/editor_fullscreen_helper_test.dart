import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_presenter.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import '../../../pal_test_utilities.dart';

void main() {
  group('[Editor] Fullscreen helper', () {
    final _navigatorKey = GlobalKey<NavigatorState>();

    EditorFullScreenHelperPresenter presenter;

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

    Route<dynamic> route(RouteSettings settings) {
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (context) => _myHomeTest);
        case '/editor/media-gallery':
          return MaterialPageRoute(
              builder: (context) => Scaffold(
                    key: ValueKey('mediaGallery'),
                  ));
        default:
          throw 'unexpected Route';
      }
    }

    // init pal + go to editor
    Future _beforeEach(WidgetTester tester) async {
      await initAppWithPal(
        tester,
        _myHomeTest,
        _navigatorKey,
        editorModeEnabled: true,
        routeFactory: route,
      );
      await pumpHelperWidget(
        tester,
        _navigatorKey,
        HelperTriggerType.ON_SCREEN_VISIT,
        HelperType.HELPER_FULL_SCREEN,
        HelperTheme.BLACK,
      );
      var presenterFinder =
          find.byKey(ValueKey("palEditorFullscreenHelperWidgetBuilder"));
      var page = presenterFinder.evaluate().first.widget as PresenterInherited<
          EditorFullScreenHelperPresenter, EditorFullScreenHelperModel>;
      presenter = page.presenter;
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
    }

    testWidgets('should add fullscreen helper', (WidgetTester tester) async {
      await _beforeEach(tester);
      expect(find.byType(EditorFullScreenHelperPage), findsOneWidget);
    });

    testWidgets('should textfield present', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.text('Edit me!'), findsOneWidget);
    });

    testWidgets('should edit fullscreen title', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.text('Edit me!'), findsOneWidget);
      var titleField = find.byKey(ValueKey('palFullscreenHelperTitleField'));
      await tester.tap(titleField.first);
      await tester.pump();
      await tester.enterText(titleField, 'Bonjour!');
      expect(find.text('Bonjour!'), findsOneWidget);
    });

    testWidgets('should save helper', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.text('Edit me!'), findsOneWidget);
      var titleField = find.byKey(ValueKey('palFullscreenHelperTitleField'));
      await tester.tap(titleField.first);
      await tester.pump();
      await tester.enterText(titleField, 'Bonjour!');
      expect(find.text('Bonjour!'), findsOneWidget);
    });

    testWidgets('should change background color', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(presenter.fullscreenHelperViewModel.backgroundColor.value,
          Colors.blueAccent);

      var colorPickerButton = find.byKey(
          ValueKey('pal_EditorFullScreenHelperPage_BackgroundColorPicker'));
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

      expect(presenter.fullscreenHelperViewModel.backgroundColor.value,
          Color(0xFFFFFFFF));
    });

    testWidgets('should edit media', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(
          find.byKey(ValueKey(
              'pal_EditorFullScreenHelperPage_EditableMedia_EditButton')),
          findsOneWidget);
    });

    testWidgets('should edit fullscreen positiv button', (WidgetTester tester) async {
      await _beforeEach(tester);

      var titleField = find.byKey(ValueKey('pal_EditorFullScreenHelper_ThanksButtonField'));
      await tester.tap(titleField.first);
      await tester.pump();
      await tester.enterText(titleField, 'Ok !');
      expect(find.text('Ok !'), findsOneWidget);
    });
  });
}
