import 'package:flutter/material.dart';
import 'package:palplugin/src/database/repository/helper_repository.dart';
import 'package:palplugin/src/database/repository/page_repository.dart';
import 'package:palplugin/src/database/repository/project_repository.dart';
import 'package:palplugin/src/database/repository/version_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

class EditorAppContext {

  static EditorAppContext _instance;

  static init({@required url, @required String token}) {
    if(_instance == null) {
      _instance = HttpEditorAppContext.create(url: url, token: token);
    }
  }

  @visibleForTesting
  static create({@required url, @required String token}) {
    _instance = HttpEditorAppContext.create(url: url, token: token);
  }

  static EditorAppContext get instance {
    if(_instance == null) {
      throw "init needs to be called";
    }
    return _instance;
  }

  HelperRepository get helperRepository => throw "not implemented";

  PageRepository get pageRepository => throw "not implemented";

  VersionRepository get versionRepository => throw "not implemented";

  ProjectRepository get projectRepository => throw "not implemented";
}

/// [EditorAppContext] inherited class to provide some context to all childs
///  - this class will retain [HttpClient] to pass to all childs
class HttpEditorAppContext implements  EditorAppContext {

  final PageRepository _pageRepository;

  final HelperRepository _helperRepository;

  final VersionRepository _versionRepository;

  final ProjectRepository _projectRepository;

  factory HttpEditorAppContext.create(
      {@required url, @required String token,})
      => HttpEditorAppContext._private(
        httpClient: url == null || token == null ? null : HttpClient.create(url, token),
      );

  HttpEditorAppContext._private({
    @required HttpClient httpClient,
  })  : assert(httpClient != null),
        this._pageRepository = PageRepository(httpClient: httpClient),
        this._projectRepository = ProjectRepository(httpClient: httpClient),
        this._helperRepository = HelperRepository(httpClient: httpClient),
        this._versionRepository = VersionHttpRepository(httpClient: httpClient);

  HelperRepository get helperRepository => this._helperRepository;

  PageRepository get pageRepository => this._pageRepository;

  VersionRepository get versionRepository => _versionRepository;

  ProjectRepository get projectRepository => _projectRepository;

}
