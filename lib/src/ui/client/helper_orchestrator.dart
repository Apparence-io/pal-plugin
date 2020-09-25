import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/client/helper_client_service.dart';
import 'package:palplugin/src/services/client/in_app_user/in_app_user_client_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';
import 'package:palplugin/src/ui/client/helper_factory.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/user_update_helper.dart';

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
  })  : assert(child != null),
        this.navigatorKey = child.navigatorKey,
        super(key: key, child: child) {
    _init();
  }

  static HelperOrchestrator of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(HelperOrchestrator old) {
    return false;
  }

  _init() async {
    this.routeObserver.routeSettings.listen((RouteSettings newRoute) async {
      if (newRoute == null || newRoute.name == null) {
        return;
      }
      onChangePage(newRoute.name);
    });
  }

  @visibleForTesting
  onChangePage(final String route) async {
    if (helper.overlay != null) {
      popHelper();
    }
    try {
      // final InAppUserEntity inAppUser =
      //     await this.inAppUserClientService.getOrCreate();
      // final List<HelperEntity> helpersToShow =
      //     await this.helperClientService.getPageHelpers(route, inAppUser.id);
      // if (helpersToShow != null && helpersToShow.length > 0) {
      //   _showHelper(helpersToShow[0], inAppUser.id);
      // }
      // DEBUG: REMOVE THIS
      _showUpdateHelper();
      // DEBUG: END REMOVE
    } catch (e) {
      // Nothing to do
    }
  }

  // this method should be private
  // TODO make one for each strategy
  _showHelper(final HelperEntity helper, final String inAppUserId) {
    OverlayEntry entry = OverlayEntry(
      opaque: false,
      builder: (context) => PalTheme(
        theme: PalThemeData.light(),
        child: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: PalTheme.of(context).buildTheme(),
            home: HelperFactory.build(helper, onTrigger: () async {
              await helperClientService.triggerHelper(
                  helper.pageId, helper.id, inAppUserId);
              this.popHelper();
            }),
          ),
        ),
      ),
    );

    var overlay = navigatorKey.currentState.overlay;
    overlay.insert(entry);
    this.helper.overlay = entry;
  }

  // DEBUG: REMOVE THIS
  _showUpdateHelper() {
    _showSpecificHelper(
      UserUpdateHelperPage(
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
  // DEBUG: REMOVE THIS END

  _showSpecificHelper(Widget helperToShow) {
    OverlayEntry entry = OverlayEntry(
      opaque: false,
      builder: (context) => PalTheme(
        theme: PalThemeData.light(),
        child: Builder(
          builder: (context) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: PalTheme.of(context).buildTheme(),
              home: helperToShow),
        ),
      ),
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
    if (overlay != null) {
      overlay.remove();
      overlay = null;
      return true;
    }
    return false;
  }
}
