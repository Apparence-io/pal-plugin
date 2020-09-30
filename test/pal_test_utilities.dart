import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/database/entity/helper/helper_theme.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/router.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

Future initAppWithPal(
  WidgetTester tester,
  Widget userApp,
  GlobalKey<NavigatorState> navigatorKey, {
  RouteFactory routeFactory,
}) async {
  BuildContext context;
  Pal app = Pal(
    appToken: "testtoken",
    editorModeEnabled: true,
    child: new MaterialApp(
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
    helperName: "helper name",
    triggerType: triggerType,
    helperType: type,
    helperTheme: theme,
  );
  var _elementFinder = ElementFinder(navigatorKey.currentContext);
  showOverlayed(
    navigatorKey,
    HelperEditorPageBuilder(args, elementFinder: _elementFinder).build,
  );
  await tester.pumpAndSettle(Duration(seconds: 1));
}
