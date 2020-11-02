import 'package:flutter/material.dart';
import 'package:pal/src/database/repository/project_gallery_repository.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';
import 'package:pal/src/pal_navigator_observer.dart';
import 'package:pal/src/services/editor/finder/finder_service.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/editor/page/page_editor_service.dart';
import 'package:pal/src/services/editor/project/app_icon_grabber_delegate.dart';
import 'package:pal/src/services/editor/project/project_editor_service.dart';
import 'package:pal/src/services/editor/project_gallery/project_gallery_editor_service.dart';
import 'package:pal/src/services/editor/versions/version_editor_service.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';

class EditorInjector extends InheritedWidget {

  final EditorHelperService _helperService;

  final PageEditorService _pageEditorService;

  final ProjectEditorService _projectEditorService;

  final VersionEditorService _versionEditorService;

  final AppIconGrabberDelegate _appIconGrabberDelegate;

  final PalEditModeStateService _palEditModeStateService;

  final FinderService _finderService;

  final PackageVersionReader _packageVersionReader;

  final ProjectGalleryEditorService _projectGalleryEditorService;

  final PalRouteObserver routeObserver;

  EditorInjector({
    Key key,
    @required EditorAppContext appContext,
    @required this.routeObserver,
    @required Widget child,
    @required GlobalKey boundaryChildKey,
  })  : assert(child != null && appContext != null),
        this._pageEditorService = PageEditorService.build(boundaryChildKey, appContext.pageRepository),
        this._projectEditorService = ProjectEditorService.build(appContext.projectRepository),
        this._helperService = EditorHelperService.build(appContext.helperRepository),
        this._finderService = FinderService(observer: routeObserver),
        this._projectGalleryEditorService = ProjectGalleryEditorService.build(
            projectGalleryRepository: appContext.projectGalleryRepository),
        this._packageVersionReader = PackageVersionReader(),
        this._appIconGrabberDelegate = AppIconGrabberDelegate(),
        this._versionEditorService = VersionEditorService.build(
            versionRepository: appContext.versionRepository,
            packageVersionReader: PackageVersionReader()),
        this._palEditModeStateService = PalEditModeStateService.build(),
        super(key: key, child: child);

  static EditorInjector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EditorInjector>();

  @override
  bool updateShouldNotify(EditorInjector old) => true;

  EditorHelperService get helperService => this._helperService;

  PageEditorService get pageEditorService => this._pageEditorService;

  PalEditModeStateService get palEditModeStateService =>
      this._palEditModeStateService;

  FinderService get finderService => this._finderService;

  ProjectEditorService get projectEditorService => this._projectEditorService;

  VersionEditorService get versionEditorService => this._versionEditorService;

  AppIconGrabberDelegate get appIconGrabberDelegate =>
      this._appIconGrabberDelegate;

  PackageVersionReader get packageVersionReader => this._packageVersionReader;

  ProjectGalleryEditorService get projectGalleryRepository => this._projectGalleryEditorService;
}
