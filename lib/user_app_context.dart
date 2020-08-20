import 'package:flutter/material.dart';
import 'package:palplugin/service/http_client/base_client.dart';

/// [UserAppContext] inherited class to provide some context to all childs
///  - this class will retain [HttpClient] to pass to all childs
class UserAppContext extends InheritedWidget {
  UserAppContext(
      {Key key, @required Widget child, @required BaseHttpClient httpClient})
      : assert(child != null),
        super(key: key, child: child);

  static UserAppContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserAppContext>();
  }

  @override
  bool updateShouldNotify(UserAppContext old) {
    return false;
  }
}
