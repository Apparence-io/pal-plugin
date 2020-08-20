import 'package:flutter/material.dart';
import 'package:palplugin/database/repository/editor/helper_repository.dart';
import 'package:palplugin/service/http_client/base_client.dart';

/// [EditorAppContext] inherited class to provide some context to all childs
///  - this class will retain [HttpClient] to pass to all childs
class EditorAppContext extends InheritedWidget {
  final HelperRepository _helperRepository;

  EditorAppContext(
      {Key key, @required Widget child, @required BaseHttpClient httpClient})
      : assert(child != null),
        this._helperRepository = HelperRepository(httpClient: httpClient),
        super(key: key, child: child);

  static EditorAppContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EditorAppContext>();
  }

  @override
  bool updateShouldNotify(EditorAppContext old) {
    return false;
  }

  HelperRepository get helperRepository => this._helperRepository;
}
