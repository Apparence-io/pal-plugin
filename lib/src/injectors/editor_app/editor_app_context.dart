import 'package:flutter/material.dart';
import 'package:pal/src/database/repository/editor/helper_editor_repository.dart';
import 'package:pal/src/database/repository/editor/helper_group_repository.dart';
import 'package:pal/src/database/repository/page_repository.dart';
import 'package:pal/src/database/repository/project_gallery_repository.dart';
import 'package:pal/src/database/repository/project_repository.dart';
import 'package:pal/src/database/repository/version_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';

class EditorAppContext {

  static EditorAppContext _instance;

  static init({@required url, @required String token}) {
    if(_instance == null) {
      _instance = HttpEditorAppContext.create(url: url, token: token);
    }
  }

  @visibleForTesting
  static create(EditorAppContext editorAppContext) {
    _instance = editorAppContext;
  }

  static EditorAppContext get instance {
    if(_instance == null) {
      throw "init needs to be called";
    }
    return _instance;
  }

  EditorHelperRepository get helperRepository => throw "not implemented";

  PageRepository get pageRepository => throw "not implemented";

  VersionRepository get versionRepository => throw "not implemented";

  ProjectRepository get projectRepository => throw "not implemented";

  ProjectGalleryRepository get projectGalleryRepository => throw "not implemented";

  EditorHelperGroupRepository get editorHelperGroupRepository => throw "not implemented";
}

/// [EditorAppContext] inherited class to provide some context to all childs
///  - this class will retain [HttpClient] to pass to all childs
class HttpEditorAppContext implements  EditorAppContext {

  final PageRepository _pageRepository;

  final EditorHelperRepository _editorHelperRepository;

  final VersionRepository _versionRepository;

  final ProjectRepository _projectRepository;

  final ProjectGalleryRepository _projectGalleryRepository;

  final EditorHelperGroupRepository _editorHelperGroupRepository;

  factory HttpEditorAppContext.create(
      {@required url, @required String token,})
      => HttpEditorAppContext.private(
        httpClient: url == null || token == null ? null : HttpClient.create(url, token),
      );

  @visibleForTesting
  HttpEditorAppContext.private({
    @required HttpClient httpClient,
  })  : assert(httpClient != null),
        this._editorHelperGroupRepository = EditorHelperGroupRepository(httpClient: httpClient),
        this._pageRepository = PageRepository(httpClient: httpClient),
        this._projectRepository = ProjectRepository(httpClient: httpClient),
        this._editorHelperRepository = EditorHelperRepository(httpClient: httpClient),
        this._projectGalleryRepository = ProjectGalleryHttpRepository(httpClient: httpClient),
        this._versionRepository = VersionHttpRepository(httpClient: httpClient);

  EditorHelperRepository get helperRepository => this._editorHelperRepository;

  PageRepository get pageRepository => this._pageRepository;

  VersionRepository get versionRepository => _versionRepository;

  ProjectRepository get projectRepository => _projectRepository;

  ProjectGalleryRepository get projectGalleryRepository => _projectGalleryRepository;

  EditorHelperGroupRepository get editorHelperGroupRepository => _editorHelperGroupRepository;

}
