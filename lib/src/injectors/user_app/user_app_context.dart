import 'package:flutter/material.dart';
import 'package:palplugin/src/database/repository/helper_repository.dart';
import 'package:palplugin/src/database/repository/in_app_user_repository.dart';
import 'package:palplugin/src/database/repository/page_repository.dart';
import 'package:palplugin/src/database/repository/version_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';


class UserAppContext {

  static UserAppContext _instance;

  static init({@required url, @required String token}) {
    if(_instance == null) {
      _instance = HttpUserAppContext.create(url: url, token: token);
    }
  }

  @visibleForTesting
  static create(UserAppContext userAppContext) {
    _instance = userAppContext;
  }

  static UserAppContext get instance {
    if(_instance == null) {
      throw "init needs to be called";
    }
    return _instance;
  }

  PageRepository get pageRepository => throw "not implemented";

  HelperRepository get helperRepository => throw "not implemented";

  VersionRepository get versionRepository => throw "not implemented";

  InAppUserRepository get inAppUserRepository => throw "not implemented";

}

/// [UserAppContext] inherited class to provide some context to all childs
///  - this class will retain [HttpClient] to pass to all childs
class HttpUserAppContext implements UserAppContext {

  final PageRepository _pageRepository;

  final HelperRepository _helperRepository;

  final InAppUserRepository _inAppUserRepository;

  final VersionRepository _versionRepository;

  factory HttpUserAppContext.create(
      {@required url, @required String token,}) {
    return HttpUserAppContext._private(
      httpClient: url == null || token == null ? null : HttpClient.create(url, token),
    );
  }

  HttpUserAppContext._private({
    @required HttpClient httpClient,
  }) : assert(httpClient != null),
      this._pageRepository = PageRepository(httpClient: httpClient),
      this._helperRepository = HelperRepository(httpClient: httpClient),
      this._versionRepository = VersionHttpRepository(httpClient: httpClient),
      this._inAppUserRepository = InAppUserRepository(httpClient: httpClient);

  PageRepository get pageRepository => this._pageRepository;

  HelperRepository get helperRepository => this._helperRepository;

  VersionRepository get versionRepository => this._versionRepository;

  InAppUserRepository get inAppUserRepository => this._inAppUserRepository;
}
