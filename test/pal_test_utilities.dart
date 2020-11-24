import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/pal.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';
import 'package:pal/src/injectors/user_app/user_app_context.dart';
import 'package:pal/src/router.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/shared/utilities/element_finder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

const Duration kLongPressTimeout = Duration(milliseconds: 500);
const Duration kPressTimeout = Duration(milliseconds: 100);

Future initAppWithPal(
    WidgetTester tester, Widget userApp, GlobalKey<NavigatorState> navigatorKey,
    {RouteFactory routeFactory,
    bool editorModeEnabled = true,
    EditorAppContext editorAppContext,
    UserAppContext userAppContext}) async {
  BuildContext context;
  if (editorAppContext != null) EditorAppContext.create(editorAppContext);
  if (userAppContext != null) UserAppContext.create(userAppContext);
  Pal app = Pal(
    appToken: "testtoken",
    editorModeEnabled: editorModeEnabled,
    childApp: new MaterialApp(
      onGenerateRoute: routeFactory ??
          (_) => MaterialPageRoute(builder: (ctx) {
                context = ctx;
                return userApp;
              }),
      navigatorKey: navigatorKey,
      navigatorObservers: [PalNavigatorObserver.instance()],
    ),
  );
  await tester.pumpWidget(app);
}

Future pumpHelperWidget(
  WidgetTester tester,
  GlobalKey<NavigatorState> navigatorKey,
  HelperTriggerType triggerType,
  HelperType type,
  HelperTheme theme,
) async {
  // push helper editor page
  HelperEditorPageArguments args = HelperEditorPageArguments(
    navigatorKey,
    "widget.pageId",
    templateViewModel: HelperViewModel(
      name: "helper name",
      triggerType: triggerType,
      helperType: type,
      helperTheme: theme,
    ),
  );
  var _elementFinder = ElementFinder(navigatorKey.currentContext);
  showOverlayed(
    navigatorKey,
    HelperEditorPageBuilder(args, elementFinder: _elementFinder).build,
  );
  await tester.pumpAndSettle(Duration(seconds: 1));
}

Future<void> longPressDrag(
  WidgetTester tester,
  Finder startElement,
  Finder endElement,
) async {
  final TestGesture drag =
      await tester.startGesture(tester.getCenter(startElement));
  await tester.pump(kLongPressTimeout + kPressTimeout);
  await drag.moveTo(tester.getBottomLeft(endElement) * 2);
  await drag.up();
}
