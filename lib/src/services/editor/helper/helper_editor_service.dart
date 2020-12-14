import 'package:flutter/cupertino.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/database/entity/pageable.dart';
import 'package:pal/src/database/entity/version_entity.dart';
import 'package:pal/src/database/repository/editor/helper_editor_repository.dart';
import 'package:pal/src/database/repository/page_repository.dart';
import 'package:pal/src/database/repository/version_repository.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';

import 'helper_editor_model_adapter.dart';

abstract class EditorHelperService {
  
  factory EditorHelperService.build(EditorAppContext appContext) =>
      _EditorHelperHttpService(appContext.helperRepository, appContext.pageRepository, appContext.versionRepository);

  factory EditorHelperService.fromDependencies(
      EditorHelperRepository _editorHelperRepository,
      VersionRepository _versionRepository,
      PageRepository _pageRepository
    ) => _EditorHelperHttpService(_editorHelperRepository, _pageRepository, _versionRepository);


  Future<Pageable<HelperEntity>> getPage(final String route, final int page, final int pageSize);

  /// saves a simple helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveSimpleHelper(final CreateSimpleHelper args);

  /// saves a fullscreen helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveFullScreenHelper(final CreateFullScreenHelper createArgs);

  /// saves an update helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveUpdateHelper(final CreateUpdateHelper createArgs);

  /// saves an anchored helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveAnchoredWidget(final CreateAnchoredHelper createArgs);

  /// Change helperPriority
  /// Priority depends on Helper type
  /// => the lower it is, the most chance we gonna show it
  Future<void> updateHelperPriority(final String pageId, final Map<String, int> priority);

  /// Delete an helper, we won't let your recover it.
  /// For stats we keep it in our database / TODO make a force arg to remove it completely
  Future<void> deleteHelper(String pageId, String helperId);
}

class _EditorHelperHttpService implements EditorHelperService {

  final EditorHelperRepository _editorHelperRepository;
  final VersionRepository _versionRepository;
  final PageRepository _pageRepository;

  _EditorHelperHttpService(this._editorHelperRepository, this._pageRepository, this._versionRepository);

  @override
  Future<HelperEntity> saveSimpleHelper(final CreateSimpleHelper createArgs) async {
    var pageId = await _getOrCreatePageId(createArgs.config.route);
    var minVersionId = await _getOrCreateVersionId(createArgs.config.minVersion);
    int maxVersionId;
    if(createArgs.config.minVersion == createArgs.config.maxVersion) {
      maxVersionId = minVersionId;
    } else if (createArgs.config.maxVersion != null) {
      maxVersionId = await _getOrCreateVersionId(createArgs.config.maxVersion);
    }
    return createArgs.config.id != null
      ? _editorHelperRepository.updateHelper(pageId, HelperEditorAdapter.parseSimpleHelper(createArgs, minVersionId, maxVersionId))
      : _editorHelperRepository.createHelper(pageId, HelperEditorAdapter.parseSimpleHelper(createArgs, minVersionId, maxVersionId));
  }


  @override
  Future<HelperEntity> saveFullScreenHelper(CreateFullScreenHelper createArgs) async {
    if (createArgs.title == null || createArgs.description == null || createArgs.title.text.isEmpty)
      throw "TITLE_AND_DESCRIPTION_REQUIRED";
    var pageId = await _getOrCreatePageId(createArgs.config.route);
    var minVersionId = await _getOrCreateVersionId(createArgs.config.minVersion);
    int maxVersionId;
    if(createArgs.config.minVersion == createArgs.config.maxVersion) {
      maxVersionId = minVersionId;
    } else if (createArgs.config.maxVersion != null) {
      maxVersionId = await _getOrCreateVersionId(createArgs.config.maxVersion);
    }
    var helperEntity = HelperEditorAdapter.parseFullscreenHelper(createArgs, minVersionId, maxVersionId);
    helperEntity.helperTexts.removeWhere((element) => element.value == null || element.value.isEmpty);
    return createArgs.config.id != null
      ? _editorHelperRepository.updateHelper(pageId, helperEntity)
      : _editorHelperRepository.createHelper(pageId, helperEntity);
  }

  @override
  Future<HelperEntity> saveUpdateHelper(CreateUpdateHelper createArgs) async {
    var pageId = await _getOrCreatePageId(createArgs.config.route);
    var minVersionId = await _getOrCreateVersionId(createArgs.config.minVersion);
    int maxVersionId;
    if(createArgs.config.minVersion == createArgs.config.maxVersion) {
      maxVersionId = minVersionId;
    } else if (createArgs.config.maxVersion != null) {
      maxVersionId = await _getOrCreateVersionId(createArgs.config.maxVersion);
    }
    var helperEntity = HelperEditorAdapter.parseUpdateHelper(createArgs, minVersionId, maxVersionId);
    helperEntity.helperTexts.removeWhere((element) => element.value == null || element.value.isEmpty);
    return createArgs.config.id != null
      ? _editorHelperRepository.updateHelper(pageId, helperEntity)
      : _editorHelperRepository.createHelper(pageId, helperEntity);
  }

  @override
  Future<HelperEntity> saveAnchoredWidget(CreateAnchoredHelper createArgs) async {
    if(createArgs.bodyBox.key.isEmpty) {
      throw "ANCHOR_KEY_MISSING";
    }
    var pageId = await _getOrCreatePageId(createArgs.config.route);
    var minVersionId = await _getOrCreateVersionId(createArgs.config.minVersion);
    int maxVersionId;
    if(createArgs.config.minVersion == createArgs.config.maxVersion) {
      maxVersionId = minVersionId;
    } else if (createArgs.config.maxVersion != null) {
      maxVersionId = await _getOrCreateVersionId(createArgs.config.maxVersion);
    }
    var helperEntity = HelperEditorAdapter.parseAnchoredHelper(createArgs, minVersionId, maxVersionId);
    return createArgs.config.id != null
      ? _editorHelperRepository.updateHelper(pageId, helperEntity)
      : _editorHelperRepository.createHelper(pageId, helperEntity);
  }

  @override
  Future<Pageable<HelperEntity>> getPage(String pageId, int page, int pageSize)
    => this._editorHelperRepository.getPage(pageId, page, pageSize);

  @override
  Future<void> updateHelperPriority(String pageId, Map<String, int> priority)
    => this._editorHelperRepository.updateHelperPriority(pageId, priority);

  @override
  Future<void> deleteHelper(String pageId, String helperId)
    => this._editorHelperRepository.deleteHelper(pageId, helperId);

  // ------------------------------------------------------------
  // PRIVATES
  // ------------------------------------------------------------

  Future<String> _getOrCreatePageId(String routeName) async {
    if (routeName == null || routeName.isEmpty) {
      throw PageCreationException(message: "EMPTY_ROUTE_PROVIDED");
    }
    PageEntity resPage = await this._pageRepository.getPage(routeName);
    if (resPage == null || resPage.id == null || resPage.id.isEmpty) {
      resPage = await this._pageRepository.createPage(
        PageEntity(route: routeName),
      );
    }
    if (resPage?.id != null && resPage.id.length > 0) {
      return resPage?.id;
    } else {
      throw PageCreationException();
    }
  }

  Future<int> _getOrCreateVersionId(String versionCode) async {
    if (versionCode == null || versionCode.isEmpty) {
      return 0;
    }
    VersionEntity resVersion = await this._versionRepository.getVersion(name: versionCode);
    if (resVersion == null || resVersion.id == null) {
      resVersion = await this._versionRepository.createVersion(
        VersionEntity(name: versionCode),
      );
    }
    if (resVersion != null) {
      return resVersion.id;
    } else {
      throw PageCreationException();
    }
  }



}

class PageCreationException implements Exception {
  final String message;

  PageCreationException({this.message});

  String toString() {
    if (message == null) return "PageCreationException";
    return "PageCreationException: $message";
  }
}

class VersionCreationException implements Exception {
  final String message;

  VersionCreationException({this.message});

  String toString() {
    if (message == null) return "VersionCreationException";
    return "VersionCreationException: $message";
  }
}
