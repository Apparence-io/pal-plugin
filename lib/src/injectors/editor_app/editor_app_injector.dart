import 'package:flutter/material.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_context.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/services/page_server.dart';

class EditorInjector extends InheritedWidget {
  final PageService _pageService;
  final HelperService _helperService;

  EditorInjector({
    Key key,
    @required EditorAppContext appContext,
    @required Widget child,
  })  : assert(child != null && appContext != null),
        this._pageService = PageService.build(appContext.pageRepository),
        this._helperService = HelperService.build(appContext.helperRepository),
        super(key: key, child: child);

  static EditorInjector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EditorInjector>();

  @override
  bool updateShouldNotify(EditorInjector old) {
    return false;
  }

  HelperService get helperService => this._helperService;

  PageService get pageService => this._pageService;
}
