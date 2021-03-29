import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/in_app_user_entity.dart';
import 'package:pal/src/pal_navigator_observer.dart';
import 'package:pal/src/services/client/helper_client_service.dart';
import 'package:pal/src/services/client/in_app_user/in_app_user_client_service.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helper_factory.dart';

import 'helpers_synchronizer.dart';


typedef OnTriggeredHelper = Future Function(bool userPositivFeedback);

/// this class is the main intelligence wether or not we are gonna show an helper to user.
/// On each page visited we check if we have to show a new helper to user
/// There is a variety of Helper types.
class HelperOrchestrator {

  static HelperOrchestrator _instance;

  final PalRouteObserver routeObserver;

  final HelperClientService helperClientService;

  final InAppUserClientService inAppUserClientService;

  final GlobalKey<NavigatorState> navigatorKey;

  final HelpersSynchronizer helpersSynchronizer;

  final PackageVersionReader packageVersionReader;

  OverlayEntry overlay;

  bool hasSync;

  factory HelperOrchestrator.getInstance({
    GlobalKey<NavigatorState> navigatorKey,
    PalRouteObserver routeObserver,
    HelperClientService helperClientService,
    InAppUserClientService inAppUserClientService,
    HelpersSynchronizer helpersSynchronizer,
    PackageVersionReader packageVersionReader,
  }) {
    if (_instance == null) {
      _instance = HelperOrchestrator._(
        routeObserver, 
        helperClientService, 
        inAppUserClientService, 
        navigatorKey, 
        helpersSynchronizer,
        packageVersionReader
      );
    }
    return _instance;
  }

  @visibleForTesting
  factory HelperOrchestrator.create({
    GlobalKey<NavigatorState> navigatorKey,
    PalRouteObserver routeObserver,
    HelperClientService helperClientService,
    InAppUserClientService inAppUserClientService,
    HelpersSynchronizer helpersSynchronizer,
    @required PackageVersionReader packageVersionReader,
  }) {
    _instance = HelperOrchestrator._(
      routeObserver, 
      helperClientService, 
      inAppUserClientService, 
      navigatorKey, 
      helpersSynchronizer,
      packageVersionReader
    );
    return _instance;
  }

  HelperOrchestrator._(
    this.routeObserver, 
    this.helperClientService, 
    this.inAppUserClientService, 
    this.navigatorKey, 
    this.helpersSynchronizer, 
    this.packageVersionReader
  ): assert(routeObserver != null),
     assert(helperClientService != null),
     assert(inAppUserClientService != null) {
    this.hasSync = false;
    this.routeObserver.routeSettings.listen((RouteSettings newRoute) async {
      if (newRoute == null || newRoute.name == null) {
        return;
      }
      await onChangePage(newRoute.name);
    });
  }

  @visibleForTesting
  onChangePage(final String route) async {
    if (overlay != null) {
      popHelper();
    }
    try {
      final InAppUserEntity inAppUser = await this.inAppUserClientService.getOrCreate();
      if(!hasSync) {
        var lang = Localizations.localeOf(navigatorKey.currentContext).languageCode;
        await this.helpersSynchronizer.sync(inAppUser.id, languageCode: lang);
        this.hasSync = true;
      }
      var test = packageVersionReader.appVersion;
      final helperGroupToShow = await helperClientService.getPageNextHelper(
        route, 
        inAppUser.id, 
        packageVersionReader.appVersion
      );
      if (helperGroupToShow != null && helperGroupToShow.helpers.isNotEmpty) {
        showHelper(
          helperGroupToShow.page.id, 
          inAppUser.id, 
          helperGroupToShow, 
          0);
      }
    } catch (e) {
      // TODO log error to our server or crashlitycs...
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
  showHelper(
    final String pageId,
    final String userId,
    final HelperGroupEntity helperGroupEntity,
    final int helperIndex) {
      var onTriggeredHelper = _buildTriggeredHelperAction(
        pageId,
        userId,
        helperGroupEntity,
        helperIndex);
      OverlayEntry entry = OverlayEntry(
        opaque: false,
        builder: (context) => PalTheme(
          theme: PalThemeData.light(),
          child: HelperFactory.build(
            helperGroupEntity.helpers[helperIndex], 
            onTrigger: onTriggeredHelper,
            onError: this.popHelper
          ),
      ));
      var overlay = navigatorKey.currentState.overlay;
      // If there is already an helper, remove it and show the next one (useful when we change page fastly)
      if (this.overlay != null) {
        this.overlay.remove();
      }
      overlay.insert(entry);
      this.overlay = entry;
  }

  OnTriggeredHelper _buildTriggeredHelperAction(
    String pageId,
    String userId,
    HelperGroupEntity helperGroupEntity,
    int helperIndex,
  ) {
    return (positivAnswer) async {
      final appversion = packageVersionReader.version;
      await helperClientService.onHelperTrigger(
        pageId, 
        helperGroupEntity, 
        helperGroupEntity.helpers[helperIndex], 
        userId, 
        positivAnswer,
        appversion);
      this.popHelper();
      if(positivAnswer && helperIndex < helperGroupEntity.helpers.length - 1 ) {
        showHelper(pageId, userId, helperGroupEntity, helperIndex + 1);
      }
    };
  }

}
