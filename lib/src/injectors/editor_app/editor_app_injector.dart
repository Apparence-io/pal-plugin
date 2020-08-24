import 'package:flutter/material.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_context.dart';
import 'package:palplugin/src/services/editor/helper/helper_service.dart';

class EditorInjector extends InheritedWidget {
  final HelperService _helperService;

  EditorInjector({
    Key key,
    @required EditorAppContext appContext,
    @required Widget child,
  })  : assert(child != null && appContext != null),
        this._helperService = HelperService.build(appContext.helperRepository),
        super(key: key, child: child);

  static EditorInjector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EditorInjector>();

  @override
  bool updateShouldNotify(EditorInjector old) {
    return false;
  }

  HelperService get helperService => this._helperService;
}
