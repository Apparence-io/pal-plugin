import 'package:flutter/material.dart';
import 'package:palplugin/src/database/adapter/project_gallery_entity_adapter.dart';
import 'package:palplugin/src/database/entity/graphic_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/base_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

abstract class ProjectGalleryRepository {
  Future<Pageable<GraphicEntity>> getAllMedias(
    final int page,
    final int pageSize,
  ) =>
      throw 'not implemented yet';
}

// FIXME: Mocked
class ProjectGalleryHttpRepository extends BaseHttpRepository
    implements ProjectGalleryRepository {
  final ProjectGalleryEntityAdapter _adapter = ProjectGalleryEntityAdapter();
  final HttpClient httpClient;

  ProjectGalleryHttpRepository({@required this.httpClient})
      : super(httpClient: httpClient);

  @override
  Future<Pageable<GraphicEntity>> getAllMedias(
    int page,
    int pageSize,
  ) async {
    // final Response response = await this
    //     .httpClient
    //     .get('editor/gallery/medias?page=$page&pageSize=$pageSize');
    // return this._adapter.parsePage(response.body);
    await Future.delayed(Duration(milliseconds: 1200));

    return Future.value(
      Pageable<GraphicEntity>(
        first: true,
        last: true,
        numberOfElements: 6,
        offset: 0,
        pageNumber: 0,
        totalPages: 1,
        totalElements: 6,
        entities: [
          GraphicEntity(
            id: '20',
            url: 'https://picsum.photos/id/20/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '21',
            url: 'https://picsum.photos/id/21/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '22',
            url: 'https://picsum.photos/id/22/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '23',
            url: 'https://picsum.photos/id/23/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '24',
            url: 'https://picsum.photos/id/24/200',
            uploadedDate: DateTime.now(),
          ),
          GraphicEntity(
            id: '25',
            url: 'https://picsum.photos/id/25/200',
            uploadedDate: DateTime.now(),
          ),
        ],
      ),
    );
  }
}
