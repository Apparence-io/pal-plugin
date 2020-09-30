import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/database/entity/helper/helper_theme.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';

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
              HelperEditorPageArguments(
                null,
                '',
                helperName: 'A name',
                triggerType: HelperTriggerType.ON_SCREEN_VISIT,
                helperType: HelperType.SIMPLE_HELPER,
                helperTheme: HelperTheme.BLACK,
              ),
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
  });
}
