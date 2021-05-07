import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/repository/editor/helper_group_repository.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';

abstract class EditorHelperGroupService {
  factory EditorHelperGroupService.build(EditorAppContext appContext) =>
      EditorHelperGroupHttpService(appContext.editorHelperGroupRepository);

  /// returns the list of groups on a route
  Future<List<HelperGroupEntity>> getPageGroups(String? route);

  Future<List<HelperEntity>> getGroupHelpers(String? groupId);

  Future<HelperGroupEntity> getGroupDetails(String? groupId);

  Future updateGroup(HelperGroupUpdate updated);

  Future deleteGroup(String? groupId);
}

class EditorHelperGroupHttpService implements EditorHelperGroupService {
  final EditorHelperGroupRepository _editorHelperGroupRepository;

  EditorHelperGroupHttpService(this._editorHelperGroupRepository);

  Future<List<HelperGroupEntity>> getPageGroups(String? pageId) =>
      _editorHelperGroupRepository.listHelperGroups(pageId);

  @override
  Future<List<HelperEntity>> getGroupHelpers(String? groupId) =>
      _editorHelperGroupRepository.listGroupHelpers(groupId);

  @override
  Future<HelperGroupEntity> getGroupDetails(String? groupId) =>
      _editorHelperGroupRepository.getGroupDetails(groupId);

  @override
  Future updateGroup(HelperGroupUpdate updated) {
    return _editorHelperGroupRepository.updateGroup(
        updated.id,
        updated.maxVersionId,
        updated.minVersionId,
        updated.name,
        helperTriggerTypeToString(updated.type));
  }

  @override
  Future deleteGroup(String? groupId) {
    return this._editorHelperGroupRepository.deleteGroup(groupId);
  }
}
