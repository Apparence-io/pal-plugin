import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/in_app_user_entity.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/client/helper_client_service.dart';
import 'package:palplugin/src/services/client/in_app_user/in_app_user_client_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';
import 'package:palplugin/src/ui/client/helper_factory.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/user_update_helper.dart';

import 'helpers/simple_helper_widget.dart';

/// this class is the main intelligence wether or not we are gonna show an helper to user.
/// On each page visited we check if we have to show a new helper to user
/// There is a variety of Helper types.
class HelperOrchestrator {

  static HelperOrchestrator _instance;

  final PalRouteObserver routeObserver;

  final HelperClientService helperClientService;

  final InAppUserClientService inAppUserClientService;
  
  final GlobalKey<NavigatorState> navigatorKey;

  OverlayEntry overlay;

  factory HelperOrchestrator.getInstance({
    GlobalKey<NavigatorState> navigatorKey,
    PalRouteObserver routeObserver, 
    HelperClientService helperClientService, 
    InAppUserClientService inAppUserClientService}) 
  {
    if(_instance == null) {
      _instance = HelperOrchestrator._(
        routeObserver, 
        helperClientService, 
        inAppUserClientService, 
        navigatorKey
      );
    }
    return _instance;
  }

  HelperOrchestrator._(this.routeObserver, this.helperClientService, this.inAppUserClientService, this.navigatorKey):
    assert(routeObserver != null),
    assert(helperClientService != null),
    assert(inAppUserClientService != null) {
    this.routeObserver.routeSettings.listen((RouteSettings newRoute) async {
      if (newRoute == null || newRoute.name == null) {
        return;
      }
      onChangePage(newRoute.name);
    });
  }

  @visibleForTesting
  onChangePage(final String route) async {
    if (overlay != null) {
      popHelper();
    }
    try {
      // DEBUG: REMOVE THIS
      // _showUpdateHelper();
      // _showSimpleHelper();
      // DEBUG: END REMOVE
      final InAppUserEntity inAppUser = await this.inAppUserClientService.getOrCreate();
      final List<HelperEntity> helpersToShow = await this.helperClientService.getPageHelpers(route, inAppUser.id);
      if (helpersToShow != null && helpersToShow.length > 0) {
        showHelper(helpersToShow[0], inAppUser.id);
      }
    } catch (e) {
      // Nothing to do
      // TODO log error to our server
      print("on change page error $e");
    }
  }

  bool popHelper() {
    if (overlay != null) {
      overlay.remove();
      overlay = null;
      return true;
    }
    return false;
  }

  @visibleForTesting
  showHelper(final HelperEntity helper, final String inAppUserId) {
    OverlayEntry entry = OverlayEntry(
      opaque: false,
      builder: (context) => PalTheme(
        theme: PalThemeData.light(),
        child: HelperFactory.build(helper, onTrigger: () async {
          await helperClientService.triggerHelper(helper.pageId, helper.id, inAppUserId);
          this.popHelper();
        }),
      )
    );
    var overlay = navigatorKey.currentState.overlay;
    overlay.insert(entry);
    this.overlay = entry;
  }


  // DEBUG: REMOVE THIS
  _showSpecificHelper(Widget helperToShow) {
    OverlayEntry entry = OverlayEntry(
      opaque: false,
      builder: (context) => PalTheme(
        theme: PalThemeData.light(),
        child: Builder(
          builder: (context) => helperToShow,
        ),
      ));
    var overlay = navigatorKey.currentState.overlay;
    overlay.insert(entry);
    this.overlay = entry;
  }

  _showUpdateHelper() {
    _showSpecificHelper(
      UserUpdateHelperPage(
        onTrigger: () async {
          this.popHelper();
        },
        backgroundColor: Color(0xff60b2d5),
        thanksButtonLabel: CustomLabel(
          text: 'Thank you !',
          fontColor: Colors.white,
          fontSize: 18.0,
        ),
        titleLabel: CustomLabel(
          text: 'New application update',
          fontColor: Colors.white,
          fontSize: 27.0,
        ),
        changelogLabels: [
          CustomLabel(
            text: 'My second app awesome feature',
            fontColor: Colors.white,
            fontSize: 14.0,
          ),
          CustomLabel(
            text: 'Another feature very useful',
            fontColor: Colors.white,
            fontSize: 14.0,
          ),
          CustomLabel(
            text: 'Any other feature',
            fontColor: Colors.white,
            fontSize: 14.0,
          ),
          CustomLabel(
            text: 'My last app awesome feature I wanna be sure you aware of',
            fontColor: Colors.white,
            fontSize: 14.0,
          ),
        ],
      ),
    );
  }

  _showSimpleHelper(){
    _showSpecificHelper(ToastLayout(
      toaster: Toaster(
        title: "Tip",
        description: "You can just disable notification by going in your profile and click on notifications tab > disable notifications",
      ),
      onDismissed: (res) => popHelper(),
    ));
  }
  // DEBUG: REMOVE THIS END
}
