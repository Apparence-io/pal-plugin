import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_presenter.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
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
      verify(helperEditorServiceMock.saveFullScreenHelper('pageId_IEPZE', any)).called(1);
      await tester.pump(Duration(seconds: 2));
      await tester.pump(Duration(milliseconds: 100));
    });

    testWidgets('save call helperService.saveFullscreen with error => shows error overlay', (WidgetTester tester) async {
      await _beforeEach(tester);
      when(helperEditorServiceMock.saveFullScreenHelper(any, any)).thenThrow(ArgumentError());
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

  });



  // group('[Editor] Fullscreen helper - creation mode (before refactoring)', () {
  //   final _navigatorKey = GlobalKey<NavigatorState>();
  //
  //   EditorFullScreenHelperPresenter presenter;
  //
  //   Scaffold _myHomeTest = Scaffold(
  //     body: Column(
  //       children: [
  //         Text(
  //           "text1",
  //           key: ValueKey("text1"),
  //         ),
  //         Text("text2", key: ValueKey("text2")),
  //         Padding(
  //           padding: EdgeInsets.only(top: 32),
  //           child: FlatButton(
  //             key: ValueKey("MFlatButton"),
  //             child: Text("tapme"),
  //             onPressed: () => print("impressed!"),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  //
  //   Route<dynamic> route(RouteSettings settings) {
  //     switch (settings.name) {
  //       case '/':
  //         return MaterialPageRoute(builder: (context) => _myHomeTest);
  //       case '/editor/media-gallery':
  //         return MaterialPageRoute(
  //             builder: (context) => Scaffold(
  //                   key: ValueKey('mediaGallery'),
  //                 ));
  //       default:
  //         throw 'unexpected Route';
  //     }
  //   }
  //
  //   // init pal + go to editor
  //   Future _beforeEach(WidgetTester tester) async {
  //     await initAppWithPal(
  //       tester,
  //       _myHomeTest,
  //       _navigatorKey,
  //       editorModeEnabled: true,
  //       routeFactory: route,
  //     );
  //     await pumpHelperWidget(
  //       tester,
  //       _navigatorKey,
  //       HelperTriggerType.ON_SCREEN_VISIT,
  //       HelperType.HELPER_FULL_SCREEN,
  //       HelperTheme.BLACK,
  //     );
  //     var presenterFinder = find.byKey(ValueKey("palEditorFullscreenHelperWidgetBuilder"));
  //     var page = presenterFinder.evaluate().first.widget
  //       as PresenterInherited<EditorFullScreenHelperPresenter, FullscreenHelperViewModel>;
  //     presenter = page.presenter;
  //     await tester.pumpAndSettle(Duration(milliseconds: 1000));
  //   }
  //
  //   testWidgets('should add fullscreen helper', (WidgetTester tester) async {
  //     await _beforeEach(tester);
  //     expect(find.byType(EditorFullScreenHelperPage), findsOneWidget);
  //   });
  //
  //   testWidgets('should textfield present', (WidgetTester tester) async {
  //     await _beforeEach(tester);
  //
  //     expect(find.byType(TextField), findsNWidgets(3));
  //     expect(find.text('Edit me!'), findsOneWidget);
  //   });
  //
  //   testWidgets('should edit fullscreen description text', (WidgetTester tester) async {
  //     await _beforeEach(tester);
  //
  //     expect(find.text('Edit me!'), findsOneWidget);
  //     var titleField = find.byKey(ValueKey('palFullscreenHelperDescriptionField'));
  //     await tester.tap(titleField.first);
  //     await tester.pump();
  //     await tester.enterText(titleField, 'Bonjour!');
  //     expect(find.text('Bonjour!'), findsOneWidget);
  //   });
  //
  //   testWidgets('should edit fullscreen title', (WidgetTester tester) async {
  //     await _beforeEach(tester);
  //
  //     expect(find.text('Edit me!'), findsOneWidget);
  //     var titleField = find.byKey(ValueKey('palFullscreenHelperTitleField'));
  //     await tester.tap(titleField.first);
  //     await tester.pump();
  //     await tester.enterText(titleField, 'Bonjour!');
  //     expect(find.text('Bonjour!'), findsOneWidget);
  //   });
  //
  //   testWidgets('should save helper', (WidgetTester tester) async {
  //     await _beforeEach(tester);
  //
  //     expect(find.text('Edit me!'), findsOneWidget);
  //     var titleField = find.byKey(ValueKey('palFullscreenHelperTitleField'));
  //     await tester.tap(titleField.first);
  //     await tester.pump();
  //     await tester.enterText(titleField, 'Bonjour!');
  //     expect(find.text('Bonjour!'), findsOneWidget);
  //   });
  //
  //   testWidgets('should change background color', (WidgetTester tester) async {
  //     await _beforeEach(tester);
  //
  //     expect(
  //       presenter.viewModel.bodyBox.backgroundColor.value,
  //       Colors.blueAccent,
  //     );
  //
  //     var colorPickerButton = find.byKey(
  //         ValueKey('pal_EditorFullScreenHelperPage_BackgroundColorPicker'));
  //     await tester.tap(colorPickerButton);
  //     await tester.pumpAndSettle();
  //
  //     expect(find.byType(ColorPickerDialog), findsOneWidget);
  //
  //     var hecColorField =
  //         find.byKey(ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'));
  //     await tester.enterText(hecColorField, '#FFFFFF');
  //     await tester.pumpAndSettle();
  //
  //     var validateColorButton =
  //         find.byKey(ValueKey('pal_ColorPickerAlertDialog_ValidateButton'));
  //     await tester.tap(validateColorButton);
  //     await tester.pumpAndSettle();
  //
  //     expect(
  //       presenter.viewModel.bodyBox.backgroundColor.value,
  //       Color(0xFFFFFFFF),
  //     );
  //   });
  //
  //   testWidgets('should edit media', (WidgetTester tester) async {
  //     await _beforeEach(tester);
  //
  //     expect(
  //         find.byKey(ValueKey(
  //             'pal_EditorFullScreenHelperPage_EditableMedia_EditButton')),
  //         findsOneWidget);
  //   });
  //
  //   testWidgets('should edit fullscreen positiv button',
  //       (WidgetTester tester) async {
  //     await _beforeEach(tester);
  //
  //     var titleField =
  //         find.byKey(ValueKey('pal_EditorFullScreenHelper_ThanksButtonField'));
  //     await tester.tap(titleField.first);
  //     await tester.pump();
  //     await tester.enterText(titleField, 'Ok !');
  //     expect(find.text('Ok !'), findsOneWidget);
  //   });
  // });
}
