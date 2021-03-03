import 'package:flutter/material.dart';
import 'package:pal/src/injectors/user_app/user_app_context.dart';
import 'package:pal/src/services/client/in_app_user/in_app_user_client_service.dart';
import 'package:pal/src/services/client/helper_client_service.dart';
import 'package:pal/src/services/client/page_client_service.dart';
import 'package:pal/src/in_app_user_manager.dart';
import 'package:pal/src/services/finder/finder_service.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/ui/client/helpers_synchronizer.dart';

import '../../pal_navigator_observer.dart';

class UserInjector extends InheritedWidget {

  final PageClientService _pageService;

  final HelperClientService _helperService;

  final InAppUserClientService _clientInAppUserService;

  final PackageVersionReader _packageVersionReader;

  final PalRouteObserver routeObserver;

  final HelpersSynchronizer _helperSynchronizeService;

  final FinderService _finderService;

  final Locale _userLocale;

  UserInjector({
    Key key,
    @required UserAppContext appContext,
    @required this.routeObserver,
    @required Widget child,
    @required Locale userLocale
  }) : assert(child != null && appContext != null),
        this._userLocale = userLocale,
        this._pageService = PageClientService.build(appContext.pageRepository),
        this._helperService = HelperClientService.build(
          clientSchemaRepository: appContext.localClientSchemaRepository,
          helperRemoteRepository: appContext.helperRepository,
          localVisitRepository: appContext.pageUserVisitLocalRepository,
          remoteVisitRepository: appContext.pageUserVisitRemoteRepository,
          userLocale: userLocale
        ),
        this._helperSynchronizeService = new HelpersSynchronizer(
          schemaLocalRepository: appContext.localClientSchemaRepository,
          schemaRemoteRepository: appContext.remoteClientSchemaRepository,
          pageUserVisitLocalRepository: appContext.pageUserVisitLocalRepository,
          pageUserVisitRemoteRepository: appContext.pageUserVisitRemoteRepository,
          packageVersionReader: PackageVersionReader(),
        ),
        this._packageVersionReader = PackageVersionReader(),
        this._clientInAppUserService = InAppUserClientService.build(appContext.inAppUserRepository),
        this._finderService = FinderService(observer: routeObserver),
        super(key: key, child: child) {
    setInAppUserManagerService(this.inAppUserClientService);
  }

  static UserInjector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserInjector>();

  @override
  bool updateShouldNotify(UserInjector old) => true;

  PageClientService get pageService => this._pageService;

  HelperClientService get helperService => this._helperService;

  PackageVersionReader get packageVersionReader => this._packageVersionReader;

  InAppUserClientService get inAppUserClientService => this._clientInAppUserService;

  HelpersSynchronizer get helpersSynchronizerService => this._helperSynchronizeService;

  FinderService get finderService => this._finderService;

  Locale get userLocale => this._userLocale;
}
