import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pal/src/database/adapter/project_gallery_entity_adapter.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/database/entity/pageable.dart';
import 'package:pal/src/database/repository/base_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';

abstract class ProjectGalleryRepository {
  Future<Pageable<GraphicEntity>> getAllMedias(
    final int page,
    final int pageSize,
  ) =>
      throw 'not implemented yet';
}

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
    final Response response = await this
        .httpClient
        .get('pal-business/editor/graphics?page=$page&pageSize=$pageSize');
    return this._adapter.parsePage(response.body);
  }
}
