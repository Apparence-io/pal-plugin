import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/repository/editor/helper_group_repository.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';

abstract class EditorHelperGroupService {

  factory EditorHelperGroupService.build(EditorAppContext appContext) =>
      EditorHelperGroupHttpService(
        appContext.editorHelperGroupRepository
      );

  /// returns the list of groups on a route
  Future<List<HelperGroupEntity>> getPageGroups(String route);

  Future<List<HelperEntity>> getGroupHelpers(String groupId);

  Future<HelperGroupEntity> getGroupDetails(String groupId);
}

class EditorHelperGroupHttpService implements EditorHelperGroupService {

  final EditorHelperGroupRepository _editorHelperGroupRepository;

  EditorHelperGroupHttpService(this._editorHelperGroupRepository);

  Future<List<HelperGroupEntity>> getPageGroups(String route) 
    => _editorHelperGroupRepository.listHelperGroups(routeName: route);

  @override
  Future<List<HelperEntity>> getGroupHelpers(String groupId) => _editorHelperGroupRepository.listGroupHelpers(groupId);

  @override
  Future<HelperGroupEntity> getGroupDetails(String groupId) => _editorHelperGroupRepository.getGroupDetails(groupId);
}