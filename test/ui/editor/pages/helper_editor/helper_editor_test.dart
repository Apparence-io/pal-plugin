import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/pal.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/editor/page/page_editor_service.dart';
import 'package:pal/src/services/editor/versions/version_editor_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class _HelperServiceMock extends Mock implements EditorHelperService {}

class _PageEditorServiceMock extends Mock implements PageEditorService {}

class _VersionEditorServiceMock extends Mock implements VersionEditorService {}

class _PalNavigatorObserverMock extends Mock implements PalNavigatorObserver {}

Future _initPage(
  WidgetTester tester,
) async {
  final helperService = _HelperServiceMock();
  final pageEditorService = _PageEditorServiceMock();
  final versionEditorService = _VersionEditorServiceMock();
  final palNavigatorObserver = _PalNavigatorObserverMock();

  final app = new MediaQuery(
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
              helperMinVersion: '1.0.0',
              templateViewModel: HelperViewModel(
                name: 'A name',
                triggerType: HelperTriggerType.ON_SCREEN_VISIT,
                helperType: HelperType.SIMPLE_HELPER,
                helperTheme: HelperTheme.BLACK,
              ),
            ),
            helperService: helperService,
            pageService: pageEditorService,
            versionEditorService: versionEditorService,
            routeObserver: palNavigatorObserver,
          ).build),
        ),
      ),
    ),
  );
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
