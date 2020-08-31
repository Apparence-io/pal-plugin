import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/helper_repository.dart';

abstract class HelperService {
  factory HelperService.build(HelperRepository helperRepository) =>
      _HelperHttpService(helperRepository);

  Future<HelperEntity> createPageHelper(
    final String pageId,
    final CreateHelperEntity createHelperEntity,
  );

  Future<Pageable<HelperEntity>> getPageHelpers(String route);
}

class _HelperHttpService implements HelperService {
  final HelperRepository _helperRepository;

  _HelperHttpService(this._helperRepository);

  @override
  Future<Pageable<HelperEntity>> getPageHelpers(final String route) {
    return this._helperRepository.getHelpers(route);
  }

  @override
  Future<HelperEntity> createPageHelper(
    String pageId,
    CreateHelperEntity createHelperEntity,
  ) {
    return this._helperRepository.createHelper(pageId, createHelperEntity);
  }
}
