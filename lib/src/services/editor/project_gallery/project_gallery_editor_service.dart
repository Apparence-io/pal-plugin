import 'package:flutter/cupertino.dart';
import 'package:palplugin/src/database/entity/graphic_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/project_gallery_repository.dart';

abstract class ProjectGalleryEditorService {
  factory ProjectGalleryEditorService.build({
    @required ProjectGalleryRepository projectGalleryRepository,
  }) =>
      ProjectGalleryEditorHttpService(projectGalleryRepository);

  Future<Pageable<GraphicEntity>> getAllMedias(final int page, final int pageSize) => throw 'not implemented yet';
}

class ProjectGalleryEditorHttpService implements ProjectGalleryEditorService {
  final ProjectGalleryRepository projectGalleryRepository;

  ProjectGalleryEditorHttpService(this.projectGalleryRepository);

  @override
  Future<Pageable<GraphicEntity>> getAllMedias(final int page, final int pageSize) {
    return this.projectGalleryRepository.getAllMedias(page, pageSize);
  }
}
