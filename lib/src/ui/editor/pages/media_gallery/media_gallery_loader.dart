import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/database/entity/pageable.dart';
import 'package:pal/src/services/editor/project_gallery/project_gallery_editor_service.dart';

import 'media_gallery_viewmodel.dart';

class MediaGalleryLoader {
  final ProjectGalleryEditorService _projectGalleryEditorService;
  final _mediasOffset = 30;
  Pageable<GraphicEntity> _pageable;

  MediaGalleryLoader(
    this._projectGalleryEditorService,
  );

  Future<MediaGalleryModel> load() async {
    var resViewModel = MediaGalleryModel();

    resViewModel.medias = await this.loadMore();

    return resViewModel;
  }

  Future<List<GraphicEntity>> loadMore() {
    return _pageable != null && _pageable.last
        ? Future.value([])
        : this
            ._projectGalleryEditorService
            .getAllMedias(
              _pageable == null ? 0 : ++_pageable.pageNumber,
              _mediasOffset,
            )
            .then(
            (res) {
              _pageable = res;
              return this._pageable.entities.toList();
            },
          );
  }
}
