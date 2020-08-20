import 'package:palplugin/database/entity/helper_entity.dart';
import 'package:palplugin/database/entity/pageable.dart';
import 'package:palplugin/database/repository/editor/helper_repository.dart';

abstract class HelperService {
  factory HelperService.build(HelperRepository helperRepository) =>
      _HelperHttpService(helperRepository);

  Future<Pageable<HelperEntity>> getPageHelpers(String route);
}

class _HelperHttpService implements HelperService {
  final HelperRepository _helperRepository;

  _HelperHttpService(this._helperRepository);

  @override
  Future<Pageable<HelperEntity>> getPageHelpers(final String route) {
    return this._helperRepository.getHelpers(route);
  }
}
