import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:palplugin/src/ui/editor/pages/helper_details/helper_details_view.dart';
import 'package:palplugin/src/ui/shared/widgets/overlayed.dart';

GlobalKey<NavigatorState> palNavigatorGlobalKey = new GlobalKey<NavigatorState>();

void globalPop() {
  Navigator.pop(palNavigatorGlobalKey.currentContext);
  // return palNavigatorGlobalKey.currentState.pop();
}

Route<dynamic> route(RouteSettings settings) {
  switch (settings.name) {
    case '/editor/new':
      CreateHelperPageArguments args = settings.arguments;

      return MaterialPageRoute(
        builder: (context) => CreateHelperPage(
          pageId: args.pageId,
          hostedAppNavigatorKey: args.hostedAppNavigatorKey,
        ),
      );
    case '/editor/helper':
      var helper = settings.arguments;
      return MaterialPageRoute(builder: (context) => HelperDetailsComponent(helper: helper,));
    case '/editor/:id/edit':
      return MaterialPageRoute(
          builder: (context) => Text('A route with id with edit'));
    default:
      throw 'unexpected Route';
  }
}

//shows a page as overlay for our editor
showOverlayed(GlobalKey<NavigatorState> hostedAppNavigatorKey, WidgetBuilder builder) {
  OverlayEntry helperOverlay = OverlayEntry(
    opaque: false,
    builder: builder,
  );
  Overlayed.of(hostedAppNavigatorKey.currentContext).entries.putIfAbsent(
    OverlayKeys.EDITOR_OVERLAY_KEY,
    () => helperOverlay,
  );
  hostedAppNavigatorKey.currentState.overlay.insert(helperOverlay);
}