import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/database/entity/pageable.dart';
import 'package:pal/src/database/repository/editor/helper_editor_repository.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';

import 'helper_editor_model_adapter.dart';

abstract class EditorHelperService {
  
  factory EditorHelperService.build(EditorHelperRepository helperRepository) =>
      _EditorHelperHttpService(helperRepository);

  Future<Pageable<HelperEntity>> getPage(final String route, final int page, final int pageSize);

  /// saves a simple helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveSimpleHelper(final String pageId, final CreateSimpleHelper args);

  /// saves a fullscreen helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveFullScreenHelper(final String pageId, final CreateFullScreenHelper createArgs);

  /// saves an update helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveUpdateHelper(final String pageId, final CreateUpdateHelper createArgs);

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

  _EditorHelperHttpService(this._editorHelperRepository);

  @override
  Future<HelperEntity> saveSimpleHelper(final String pageId, final CreateSimpleHelper createArgs)
    => createArgs.config.id != null
      ? _editorHelperRepository.updateHelper(pageId, HelperEditorAdapter.parseSimpleHelper(pageId, createArgs))
      : _editorHelperRepository.createHelper(pageId, HelperEditorAdapter.parseSimpleHelper(pageId, createArgs));


  @override
  Future<HelperEntity> saveFullScreenHelper(String pageId, CreateFullScreenHelper createArgs) {
    if (createArgs.title == null || createArgs.description == null || createArgs.title.text.isEmpty)
      throw "TITLE_AND_DESCRIPTION_REQUIRED";
    var helperEntity = HelperEditorAdapter.parseFullscreenHelper(pageId, createArgs);
    helperEntity.helperTexts.removeWhere((element) => element.value == null || element.value.isEmpty);
    return createArgs.config.id != null
      ? _editorHelperRepository.updateHelper(pageId, helperEntity)
      : _editorHelperRepository.createHelper(pageId, helperEntity);
  }

  @override
  Future<HelperEntity> saveUpdateHelper(String pageId, CreateUpdateHelper createArgs) {
    var helperEntity = HelperEditorAdapter.parseUpdateHelper(pageId, createArgs);
    helperEntity.helperTexts.removeWhere((element) => element.value == null || element.value.isEmpty);
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
}
