import 'package:flutter/material.dart';
import 'package:palplugin/user_app_context.dart';

class UserInjector extends InheritedWidget {
  UserInjector({
    Key key,
    @required UserAppContext appContext,
    @required Widget child,
  })  : assert(child != null && appContext != null),
        super(key: key, child: child);

  static UserInjector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserInjector>();

  @override
  bool updateShouldNotify(UserInjector old) {
    return false;
  }
}
