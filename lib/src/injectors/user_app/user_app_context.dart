import 'package:flutter/material.dart';
import 'package:palplugin/src/database/repository/helper_repository.dart';
import 'package:palplugin/src/database/repository/page_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

/// [UserAppContext] inherited class to provide some context to all childs
///  - this class will retain [HttpClient] to pass to all childs
class UserAppContext extends InheritedWidget {

  final PageRepository _pageRepository;
  final HelperRepository _helperRepository;

  factory UserAppContext.create(
      {@required Key key, @required Widget child, @required url, @required String token,}) =>
      UserAppContext._private(
        key: key,
        child: child,
        httpClient: url == null || token == null ? null : HttpClient.create(
            url, token),
      );


  UserAppContext._private({
    @required Key key,
    @required Widget child,
    @required HttpClient httpClient,
  })  : assert(child != null),
        assert(httpClient != null),
        this._pageRepository = PageRepository(httpClient: httpClient),
        this._helperRepository = HelperRepository(httpClient: httpClient),
        super(key: key, child: child);

  static UserAppContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserAppContext>();
  }

  @override
  bool updateShouldNotify(UserAppContext old) {
    return false;
  }

  PageRepository get pageRepository => this._pageRepository;

  HelperRepository get helperRepository => this._helperRepository;
}
