import 'package:flutter/material.dart';
import 'package:pal/src/ui/editor/pages/app_settings/app_settings.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_details/helper_details_view.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_family_picker/font_family_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

GlobalKey<NavigatorState> palNavigatorGlobalKey =
    new GlobalKey<NavigatorState>();

void globalPop() {
  Navigator.pop(palNavigatorGlobalKey.currentContext);
  // return palNavigatorGlobalKey.currentState.pop();
}

Route<dynamic> route(RouteSettings settings) {
  switch (settings.name) {
    case '/settings':
      return MaterialPageRoute(
        builder: (context) => AppSettingsPage(),
      );
    case '/editor/new':
      CreateHelperPageArguments args = settings.arguments;

      return MaterialPageRoute(
        builder: (context) => CreateHelperPage(
          pageId: args.pageId,
          hostedAppNavigatorKey: args.hostedAppNavigatorKey,
        ),
      );
    case '/editor/helper':
      HelperDetailsComponentArguments arguments = settings.arguments;

      return MaterialPageRoute(
        builder: (context) => HelperDetailsComponent(
          arguments: arguments,
        ),
      );
    case '/editor/new/font-family':
      FontFamilyPickerArguments args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => FontFamilyPickerPage(
                arguments: args,
              ));
    case '/editor/new/font-weight':
      FontWeightPickerArguments args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => FontWeightPickerPage(
                arguments: args,
              ));
    case '/editor/media-gallery':
      MediaGalleryPageArguments args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => MediaGalleryPage(
                mediaId: args.mediaId,
              ));
    // case '/editor/:id':
    //   return MaterialPageRoute(builder: (context) => Text('A route with id'));
    // case '/editor/:id/edit':
    //   return MaterialPageRoute(
    //       builder: (context) => Text('A route with id with edit'));
    default:
      throw 'unexpected Route';
  }
}

//shows a page as overlay for our editor
showOverlayed(
    GlobalKey<NavigatorState> hostedAppNavigatorKey, WidgetBuilder builder) {
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
