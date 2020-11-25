import 'package:flutter/material.dart';
import 'package:pal/src/database/hive_client.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/page_user_visit_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/database/repository/in_app_user_repository.dart';
import 'package:pal/src/database/repository/page_repository.dart';
import 'package:pal/src/database/repository/version_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';


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

  ClientHelperRepository get helperRepository => throw "not implemented";

  VersionRepository get versionRepository => throw "not implemented";

  InAppUserRepository get inAppUserRepository => throw "not implemented";

  ClientSchemaRepository get localClientSchemaRepository => throw "not implemented";

  ClientSchemaRepository get remoteClientSchemaRepository => throw "not implemented";

  HelperGroupUserVisitRepository get pageUserVisitRemoteRepository => throw "not implemented";

  HelperGroupUserVisitRepository get pageUserVisitLocalRepository => throw "not implemented";

}

/// [UserAppContext] inherited class to provide some context to all childs
///  - this class will retain [HttpClient] to pass to all childs
class HttpUserAppContext implements UserAppContext {

  final PageRepository _pageRepository;

  final ClientHelperRepository _helperRepository;

  final InAppUserRepository _inAppUserRepository;

  final VersionRepository _versionRepository;

  final HelperGroupUserVisitRepository _pageUserVisitRemoteRepository, _pageUserVisitLocalRepository;

  final ClientSchemaRepository _clientSchemaLocalRepository, _clientSchemaRemoteRepository;

  factory HttpUserAppContext.create({@required url, @required String token})
    => HttpUserAppContext._private(
      hiveClient: HiveClient(),
      httpClient: url == null || token == null ? null : HttpClient.create(url, token)
    );

  HttpUserAppContext._private({
    @required HiveClient hiveClient,
    @required HttpClient httpClient,
  }) : assert(httpClient != null),
      this._pageUserVisitRemoteRepository = HelperGroupUserVisitHttpRepository(httpClient: httpClient),
      this._pageUserVisitLocalRepository = HelperGroupUserVisitLocalRepository(hiveBoxOpener: hiveClient.openVisitsBox),
      this._clientSchemaLocalRepository = ClientSchemaLocalRepository(hiveBoxOpener: hiveClient.openSchemaBox),
      this._clientSchemaRemoteRepository = ClientSchemaRemoteRepository(httpClient: httpClient),
      this._pageRepository = PageRepository(httpClient: httpClient),
      this._helperRepository = ClientHelperRepository(httpClient: httpClient),
      this._versionRepository = VersionHttpRepository(httpClient: httpClient),
      this._inAppUserRepository = InAppUserRepository(httpClient: httpClient);

  @override
  PageRepository get pageRepository => _pageRepository;

  @override
  ClientHelperRepository get helperRepository => _helperRepository;

  @override
  VersionRepository get versionRepository => _versionRepository;

  @override
  InAppUserRepository get inAppUserRepository => _inAppUserRepository;

  @override
  ClientSchemaRepository get localClientSchemaRepository => _clientSchemaLocalRepository;

  @override
  ClientSchemaRepository get remoteClientSchemaRepository => _clientSchemaRemoteRepository;

  @override
  HelperGroupUserVisitRepository get pageUserVisitRemoteRepository => _pageUserVisitRemoteRepository;

  @override
  HelperGroupUserVisitRepository get pageUserVisitLocalRepository => _pageUserVisitLocalRepository;
}
