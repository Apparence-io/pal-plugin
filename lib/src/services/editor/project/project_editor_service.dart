import 'dart:typed_data';

import 'package:pal/src/database/repository/project_repository.dart';

abstract class ProjectEditorService {
  factory ProjectEditorService.build(
    ProjectRepository projectRepository,
  ) =>
      ProjectEditorHttpService(projectRepository);

  Future sendAppIcon(Uint8List icon) => throw "not implemented yet";
}

class ProjectEditorHttpService implements ProjectEditorService {
  final ProjectRepository projectRepository;

  ProjectEditorHttpService(this.projectRepository);

  @override
  Future sendAppIcon(Uint8List icon) async {
    // TODO: I created a "create" & "update" method,
    // but seems to be better to just use "send" method,
    // and then Back will create OR update if already exist :)
    await Future.delayed(Duration(milliseconds: 3500));
    return Future.value(true);

    // FIXME: MOCKED THING
    // return this.projectRepository.createAppIcon(projectId, imageData, imageType, imageDate);
  }
}
