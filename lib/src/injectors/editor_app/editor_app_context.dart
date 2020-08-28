import 'package:flutter/material.dart';
import 'package:palplugin/src/database/repository/helper_repository.dart';
import 'package:palplugin/src/database/repository/page_repository.dart';
import 'package:palplugin/src/database/repository/version_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

/// [EditorAppContext] inherited class to provide some context to all childs
///  - this class will retain [HttpClient] to pass to all childs
class EditorAppContext extends InheritedWidget {

  final PageRepository _pageRepository;

  final HelperRepository _helperRepository;

  final VersionRepository _versionRepository;


  EditorAppContext({
    Key key,
    @required Widget child,
    @required BaseHttpClient httpClient,
  })  : assert(child != null),
        this._pageRepository = PageRepository(httpClient: httpClient),
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


}
