import 'package:flutter/material.dart';
import 'package:palplugin/src/injectors/user_app/user_app_context.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/services/page_server.dart';

class UserInjector extends InheritedWidget {
  final PageService _pageService;
  final HelperService _helperService;

  UserInjector({
    Key key,
    @required UserAppContext appContext,
    @required Widget child,
  })  : assert(child != null && appContext != null),
        this._pageService = PageService.build(appContext.pageRepository),
        this._helperService = HelperService.build(appContext.helperRepository),
        super(key: key, child: child);

  static UserInjector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserInjector>();

  @override
  bool updateShouldNotify(UserInjector old) {
    return false;
  }

  PageService get pageService => this._pageService;

  HelperService get helperService => this._helperService;
}
