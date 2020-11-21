import 'dart:typed_data';

import 'package:pal/src/database/entity/app_icon_entity.dart';
import 'package:pal/src/database/repository/project_repository.dart';

abstract class ProjectEditorService {
  factory ProjectEditorService.build(
    ProjectRepository projectRepository,
  ) =>
      ProjectEditorHttpService(projectRepository);

  Future<AppIconEntity> sendAppIcon(Uint8List icon, String imageType) => throw "not implemented yet";
  Future<AppIconEntity> updateAppIcon(String appIconId, Uint8List icon, String imageType) => throw "not implemented yet";
  Future<AppIconEntity> getAppIcon() => throw "not implemented yet";

}

class ProjectEditorHttpService implements ProjectEditorService {
  final ProjectRepository projectRepository;

  ProjectEditorHttpService(this.projectRepository);

  @override
  Future<AppIconEntity> sendAppIcon(Uint8List icon, String imageType) async {
    return this.projectRepository.createAppIcon( icon, imageType);
  }

  Future<AppIconEntity> updateAppIcon(String appIconId, Uint8List icon, String imageType) async {
    return this.projectRepository.updateAppIcon(appIconId, icon, imageType);
  }

  @override
  Future<AppIconEntity> getAppIcon() {
    return this.projectRepository.getAppIcon();
  }
}
