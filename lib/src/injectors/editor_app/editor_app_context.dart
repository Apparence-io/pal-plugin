import 'package:flutter/material.dart';
import 'package:palplugin/src/database/repository/helper_repository.dart';
import 'package:palplugin/src/database/repository/page_repository.dart';
import 'package:palplugin/src/database/repository/project_repository.dart';
import 'package:palplugin/src/database/repository/version_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

/// [EditorAppContext] inherited class to provide some context to all childs
///  - this class will retain [HttpClient] to pass to all childs
class EditorAppContext extends InheritedWidget {

  final PageRepository _pageRepository;

  final HelperRepository _helperRepository;

  final VersionRepository _versionRepository;

  final ProjectRepository _projectRepository;

  factory EditorAppContext.create(
      {Key key, @required Widget child, @required url, @required String token,}) =>
      EditorAppContext._private(
        key: key,
        child: child,
        httpClient: url == null || token == null ? null : HttpClient.create(
            url, token),
      );

  EditorAppContext._private({
    Key key,
    @required Widget child,
    @required HttpClient httpClient,
  })  : assert(child != null),
        assert(httpClient != null),
        this._pageRepository = PageRepository(httpClient: httpClient),
        this._projectRepository = ProjectRepository(httpClient: httpClient),
        this._helperRepository = HelperRepository(httpClient: httpClient),
        this._versionRepository = VersionHttpRepository(httpClient: httpClient),
        super(key: key, child: child);

  static EditorAppContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EditorAppContext>();
  }

  @override
  bool updateShouldNotify(EditorAppContext old) {
    return false;
  }

  HelperRepository get helperRepository => this._helperRepository;

  PageRepository get pageRepository => this._pageRepository;

  VersionRepository get versionRepository => _versionRepository;

  ProjectRepository get projectRepository => _projectRepository;

}
