import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/pal.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';
import 'package:pal/src/injectors/user_app/user_app_context.dart';
import 'package:pal/src/router.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper.dart';
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
  BuildContext context; // ignore: unused_local_variable
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

/// use this to show an helper editor for each type
/// they will be shown as overlay as we do in application
/// provide [EditorHelperService] to mock the service
Future pumpHelperWidget(
  WidgetTester tester,
  GlobalKey<NavigatorState> navigatorKey,
  HelperTriggerType triggerType,
  HelperType type,
  HelperTheme theme,
  {EditorHelperService editorHelperService}
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
  // CREATE AN EDITOR FACTORY
  var _elementFinder = ElementFinder(navigatorKey.currentContext);
  WidgetBuilder builder;
  switch(type) {
    case HelperType.SIMPLE_HELPER:
      builder = (context) => EditorSimpleHelperPage.create(
          parameters: args,
          helperViewModel: args.templateViewModel,
          helperService: editorHelperService,
        );
      break;
    case HelperType.HELPER_FULL_SCREEN:
      builder = (context) => EditorFullScreenHelperPage.create(
          parameters: args,
          helperViewModel: args.templateViewModel,
          helperService: editorHelperService,
        );
      break;
    default:
      throw 'HELPER TYPE NOT HANDLED';
  }
  //HelperEditorPageBuilder(args, elementFinder: _elementFinder).build,
  showOverlayed(navigatorKey, builder);
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
