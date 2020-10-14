import 'package:flutter/material.dart';
import 'package:palplugin/src/injectors/user_app/user_app_context.dart';
import 'package:palplugin/src/services/client/in_app_user/in_app_user_client_service.dart';
import 'package:palplugin/src/services/client/helper_client_service.dart';
import 'package:palplugin/src/services/client/page_client_service.dart';
import 'package:palplugin/src/in_app_user_manager.dart';
import 'package:palplugin/src/services/package_version.dart';

import '../../pal_navigator_observer.dart';

class UserInjector extends InheritedWidget {

  final PageClientService _pageService;

  final HelperClientService _helperService;

  final InAppUserClientService _clientInAppUserService;

  final PackageVersionReader _packageVersionReader;

  final PalRouteObserver routeObserver;

  UserInjector({
    Key key,
    @required UserAppContext appContext,
    @required this.routeObserver,
    @required Widget child,
  })  : assert(child != null && appContext != null),
        this._pageService = PageClientService.build(appContext.pageRepository),
        this._helperService = HelperClientService.build(appContext),
        this._packageVersionReader = PackageVersionReader(),
        this._clientInAppUserService = InAppUserClientService.build(
            appContext.inAppUserRepository),
        super(key: key, child: child){
    setInAppUserManagerService(this.inAppUserClientService);
  }

  static UserInjector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserInjector>();

  @override
  bool updateShouldNotify(UserInjector old) {
    return false;
  }

  PageClientService get pageService => this._pageService;

  HelperClientService get helperService => this._helperService;

  PackageVersionReader get packageVersionReader => this._packageVersionReader;

  InAppUserClientService get inAppUserClientService => this._clientInAppUserService;
}
