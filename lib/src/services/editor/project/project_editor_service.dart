import 'dart:typed_data';

import 'package:pal/src/database/entity/app_icon_entity.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/repository/editor/helper_editor_repository.dart';
import 'package:pal/src/database/repository/editor/helper_group_repository.dart';
import 'package:pal/src/database/repository/project_repository.dart';

abstract class ProjectEditorService {

  factory ProjectEditorService.build(
    ProjectRepository projectRepository,
    EditorHelperGroupRepository editorHelperGroupRepository,
    EditorHelperRepository editorHelperRepository
  ) => ProjectEditorHttpService(
    projectRepository,
    editorHelperGroupRepository,
    editorHelperRepository
  );

  Future<AppIconEntity> sendAppIcon(Uint8List icon, String imageType) => throw "not implemented yet";

  Future<AppIconEntity> updateAppIcon(String? appIconId, Uint8List icon, String imageType) => throw "not implemented yet";

  Future<AppIconEntity> getAppIcon() => throw "not implemented yet";

  Future<List<HelperGroupEntity>> getPageGroups(String? routeName) => throw "not implemented yet";

  Future<List<HelperEntity>> getGroupHelpers(String? groupId) => throw "not implemented yet";
}

class ProjectEditorHttpService implements ProjectEditorService {

  final ProjectRepository projectRepository;
  final EditorHelperGroupRepository editorHelperGroupRepository;
  final EditorHelperRepository editorHelperRepository;

  ProjectEditorHttpService(
    this.projectRepository,
    this.editorHelperGroupRepository,
    this.editorHelperRepository
  );

  @override
  Future<AppIconEntity> sendAppIcon(Uint8List icon, String imageType)
    => this.projectRepository.createAppIcon( icon, imageType);

  Future<AppIconEntity> updateAppIcon(String? appIconId, Uint8List icon, String imageType)
    => this.projectRepository.updateAppIcon(appIconId, icon, imageType);

  @override
  Future<AppIconEntity> getAppIcon()
    => this.projectRepository.getAppIcon();

  @override
  Future<List<HelperGroupEntity>> getPageGroups(String? pageId)
    => editorHelperGroupRepository.listHelperGroups(pageId);

  @override
  Future<List<HelperEntity>> getGroupHelpers(String? groupId)
    => editorHelperRepository.getGroupHelpers(groupId);

}
