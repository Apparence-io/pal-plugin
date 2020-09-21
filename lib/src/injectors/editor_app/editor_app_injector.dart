import 'package:flutter/material.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_context.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/editor/finder/finder_service.dart';
import 'package:palplugin/src/services/editor/page/page_editor_service.dart';
import 'package:palplugin/src/services/editor/project/project_editor_service.dart';
import 'package:palplugin/src/services/editor/versions/version_editor_service.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/services/page_server.dart';
import 'package:palplugin/src/services/pal/pal_state_service.dart';

class EditorInjector extends InheritedWidget {

  final PageService _pageService;

  final HelperService _helperService;

  final PageEditorService _pageEditorService;

  final ProjectEditorService _projectEditorService;

  final VersionEditorService _versionEditorService;

  final PalEditModeStateService _palEditModeStateService;

  final FinderService _finderService;

  final PalRouteObserver routeObserver;

  EditorInjector({
    Key key,
    @required EditorAppContext appContext,
    @required this.routeObserver,
    @required Widget child,
    @required GlobalKey boundaryChildKey, 
  })  : assert(child != null && appContext != null),
        this._pageEditorService = PageEditorService.build(boundaryChildKey),
        this._projectEditorService = ProjectEditorService.build(),
        this._pageService = PageService.build(appContext.pageRepository),
        this._helperService = HelperService.build(appContext.helperRepository),
        this._finderService = FinderService(observer: routeObserver),
        this._versionEditorService = VersionEditorService.build(
          versionRepository: appContext.versionRepository,
          packageVersionReader: PackageVersionReader()
        ),
        this._palEditModeStateService = PalEditModeStateService.build(),
        super(key: key, child: child);

  static EditorInjector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EditorInjector>();

  @override
  bool updateShouldNotify(EditorInjector old) {
    return false;
  }

  HelperService get helperService => this._helperService;

  PageEditorService get pageEditorService => this._pageEditorService;

  PageService get pageService => this._pageService;

  PalEditModeStateService get palEditModeStateService => this._palEditModeStateService;

  FinderService get finderService => this._finderService;
}
