import 'package:flutter/material.dart';
import 'package:pal/src/ui/editor/pages/app_settings/app_settings.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:pal/src/ui/editor/pages/group_details/group_details.dart';
import 'package:pal/src/ui/editor/pages/group_details/group_details_model.dart';
// import 'package:pal/src/ui/editor/pages/helper_details/helper_details_view.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_family_picker/font_family_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery.dart';
import 'package:pal/src/ui/editor/pages/page_groups/page_group_list_model.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import 'database/entity/helper/helper_group_entity.dart';
import 'ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';

GlobalKey<NavigatorState> palNavigatorGlobalKey =
    new GlobalKey<NavigatorState>();

Route<dynamic> route(RouteSettings settings) {
  print("root router... ${settings.name}");
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
    case '/editor/group/details':
      String groupId = (settings.arguments as Map)["id"];
      String pageRoute = (settings.arguments as Map)["route"];
      PageStep startPage = (settings.arguments as Map)["page"];
      return PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, a, b) => GroupDetailsPage(
            groupId: groupId, routeName: pageRoute, page: startPage),
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
    case '/editor/preview':
      EditorPreviewArguments args = settings.arguments;
      return PageRouteBuilder(
        maintainState: true,
        opaque: false,
        pageBuilder: (context,_,__) => EditorPreviewPage(
          args: args,
        ),
      );
    default:
      throw 'unexpected Route';
  }
}

//shows a page as overlay for our editor
showOverlayed(
    GlobalKey<NavigatorState> hostedAppNavigatorKey, WidgetBuilder builder,
    {OverlayKeys key, Function onPop}) {
  EditorOverlayEntry helperOverlay = EditorOverlayEntry(
    onPop,
    opaque: false,
    builder: builder,
  );
  Overlayed.of(hostedAppNavigatorKey.currentContext).entries.putIfAbsent(
        key ?? OverlayKeys.EDITOR_OVERLAY_KEY,
        () => helperOverlay,
      );
  hostedAppNavigatorKey.currentState.overlay.insert(helperOverlay);
}

showOverlayedInContext(WidgetBuilder builder,
    {OverlayKeys key, Function onPop}) {
  if (Overlayed.of(palNavigatorGlobalKey.currentState.context)
      .entries
      .containsKey(key ?? OverlayKeys.EDITOR_OVERLAY_KEY)) {
    return;
  }
  EditorOverlayEntry helperOverlay = EditorOverlayEntry(
    onPop,
    opaque: false,
    builder: builder,
  );
  Overlayed.of(palNavigatorGlobalKey.currentState.context).entries.putIfAbsent(
        key ?? OverlayKeys.EDITOR_OVERLAY_KEY,
        () => helperOverlay,
      );
  palNavigatorGlobalKey.currentState.overlay.insert(helperOverlay);
}

closeOverlayed(OverlayKeys key) {
  Overlayed.of(palNavigatorGlobalKey.currentState.context)
      .entries[key]
      .remove();
  Overlayed.of(palNavigatorGlobalKey.currentState.context).entries.remove(key);
}
