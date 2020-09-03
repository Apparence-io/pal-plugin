import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_full_screen_entity.dart';
import 'package:palplugin/src/database/entity/in_app_user_entity.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/client/helper_client_service.dart';
import 'package:palplugin/src/services/client/in_app_user/in_app_user_client_service.dart';
import 'package:palplugin/src/ui/client/helper_factory.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper_widget.dart';

/// this class is the main intelligence wether or not we are gonna show an helper to user.
/// On each page visited we check if we have to show a new helper to user
/// There is a variety of Helper types.
/// it should be placed above MaterialApp
class HelperOrchestrator extends InheritedWidget {

  final HelperInstance helper = HelperInstance();

  final PalRouteObserver routeObserver;

  final HelperClientService helperClientService;

  final InAppUserClientService inAppUserClientService;

  final GlobalKey<NavigatorState> navigatorKey;

  HelperOrchestrator({
    Key key,
    @required MaterialApp child,
    @required this.routeObserver,
    @required this.helperClientService,
    @required this.inAppUserClientService,
  }): assert(child != null),
    this.navigatorKey = child.navigatorKey,
    super(key: key, child: child) {
    _init();
  }

  static HelperOrchestrator of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(HelperOrchestrator old) {
    return false;
  }

  _init() async {
    this.routeObserver.stream.listen((RouteSettings newRoute) async {
      if(newRoute == null || newRoute.name == null) {
        return;
      }
      onChangePage(newRoute.name);
    });
  }

  @visibleForTesting
  onChangePage(String route) async {
    if(helper.overlay != null) {
      popHelper();
    }
    try {
      final List<HelperEntity> helpersToShow = await this.inAppUserClientService.getOrCreate()
          .then((inAppUser) => this.helperClientService.getPageHelpers(route, inAppUser.id));
      if (helpersToShow != null && helpersToShow.length > 0) {
        _showHelper(helpersToShow[0]);
      }
    } catch (e) {
      // Nothing to do
    }
  }

  // this method should be private
  // TODO make one for each strategy
  _showHelper(HelperEntity helper) {
    OverlayEntry entry = OverlayEntry(
      opaque: false,
      builder: (context) => HelperFactory.build(helper),
    );
    var overlay = navigatorKey.currentState.overlay;
    overlay.insert(entry);
    this.helper.overlay = entry;
  }

  bool popHelper() => helper.pop();
}

class HelperInstance {

  OverlayEntry overlay;

  bool pop() {
    if(overlay != null) {
      overlay.remove();
      overlay = null;
      return true;
    }
    return false;
  }

}