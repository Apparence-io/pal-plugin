import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/group_details/group_details_model.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_family_picker/font_family_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery.dart';

import '../../../../router.dart';
import 'helpers/editor_anchored_helper/editor_anchored_helper.dart';
import 'helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'helpers/editor_simple_helper/editor_simple_helper.dart';
import 'helpers/editor_update_helper/editor_update_helper.dart';

/// this class will show the correct helper editor for each types
/// we don't use a navigator push as we use the overlay feature for
/// reaching the overlayed page elements (@see anchoredHelper)
class EditorRouter {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;

  EditorRouter(this.hostedAppNavigatorKey);

  /// Open editor page as an overlay
  Future createHelper(
      final String currentPageRoute, final CreateHelperModel model) async {
    // var elementFinder = ElementFinder(hostedAppNavigatorKey.currentContext);
    HelperEditorPageArguments args = HelperEditorPageArguments(
      hostedAppNavigatorKey,
      currentPageRoute,
      helperMinVersion: model.minVersion,
    );
    WidgetBuilder builder;
    switch (model.selectedHelperType) {
      case HelperType.SIMPLE_HELPER:
        builder = (context) => InnerEditorRouter(
              child: EditorSimpleHelperPage.create(
                parameters: args,
                helperViewModel: model.asHelperViewModel(),
              ),
            );
        break;
      case HelperType.UPDATE_HELPER:
        builder = (context) => InnerEditorRouter(
              child: EditorUpdateHelperPage.create(
                parameters: args,
                helperViewModel: model.asHelperViewModel(),
              ),
            );
        break;
      case HelperType.HELPER_FULL_SCREEN:
        builder = (context) => InnerEditorRouter(
              child: EditorFullScreenHelperPage.create(
                parameters: args,
                helperViewModel: model.asHelperViewModel(),
              ),
            );
        break;
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        builder = (context) => InnerEditorRouter(
              child: EditorAnchoredFullscreenHelper.create(
                parameters: args,
                helperViewModel: model.asHelperViewModel(),
              ),
            );
        break;
      default:
        throw 'HELPER TYPE NOT HANDLED';
    }
    showOverlayed(hostedAppNavigatorKey, builder);
  }

  Future editHelper(final String currentPageRoute, final String helperId,
      final HelperType type, final String groupId,
      {BuildContext con}) async {
    // var elementFinder = ElementFinder(hostedAppNavigatorKey.currentContext);
    HelperEditorPageArguments args = HelperEditorPageArguments(
      hostedAppNavigatorKey,
      currentPageRoute,
    );
    WidgetBuilder builder;
    switch (type) {
      case HelperType.SIMPLE_HELPER:
        builder = (context) => InnerEditorRouter(
              child: EditorSimpleHelperPage.edit(
                parameters: args,
                helperId: helperId,
              ),
            );
        break;
      case HelperType.UPDATE_HELPER:
        builder = (context) => InnerEditorRouter(
              child: EditorUpdateHelperPage.edit(
                parameters: args,
                helperId: helperId,
              ),
            );
        break;
      case HelperType.HELPER_FULL_SCREEN:
        builder = (context) => InnerEditorRouter(
              child: EditorFullScreenHelperPage.edit(
                parameters: args,
                helperId: helperId,
              ),
            );
        break;
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        builder = (context) => InnerEditorRouter(
              child: EditorAnchoredFullscreenHelper.edit(
                parameters: args,
                helperId: helperId,
              ),
            );
        break;
      default:
        throw 'HELPER TYPE NOT HANDLED';
    }
    return showOverlayed(
      hostedAppNavigatorKey,
      builder,
      onPop: () => Navigator.of(con).pushNamed(
        '/editor/group/details',
        arguments: {
          "id": groupId,
          "route": currentPageRoute,
          "page": PageStep.HELPERS
        },
      ),
    );
  }
}

/// Editor has some pages to show like change font, color...
/// so it has his own routing strategy
class InnerEditorRouter extends StatefulWidget {
  final Widget child;

  InnerEditorRouter({@required this.child});

  @override
  _InnerEditorRouterState createState() => _InnerEditorRouterState();
}

class _InnerEditorRouterState extends State<InnerEditorRouter> {
  final GlobalKey<NavigatorState> innerEditorNavKey =
      GlobalKey<NavigatorState>();
  InnerEditorRouterDelegate _routerDelegate;

  void initState() {
    super.initState();
    _routerDelegate = InnerEditorRouterDelegate(
        child: widget.child, innerEditorNavKey: innerEditorNavKey);
  }

  @override
  void didUpdateWidget(covariant InnerEditorRouter oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: _routerDelegate,
    );
  }
}

abstract class InnerEditorRoutePath {}

class InnerEditorRouterDelegate extends RouterDelegate<InnerEditorRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> innerEditorNavKey;

  Widget child;

  InnerEditorRouterDelegate({this.child, this.innerEditorNavKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: innerEditorNavKey,
      onGenerateRoute: (RouteSettings settings) {
        // TODO: Remove unused font family et font weight
        switch (settings.name) {
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
              pageBuilder: (context, _, __) => EditorPreviewPage(
                args: args,
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => child,
              maintainState: true,
            );
        }
      },
      onPopPage: (route, result) {
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => innerEditorNavKey;

  @override
  Future<void> setNewRoutePath(InnerEditorRoutePath configuration) {
    throw UnimplementedError();
  }
}
