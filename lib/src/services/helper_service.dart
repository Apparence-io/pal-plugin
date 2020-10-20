import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/helper_repository.dart';

abstract class HelperService {

  factory HelperService.build(HelperRepository helperRepository) => _HelperHttpService(helperRepository);

  Future<Pageable<HelperEntity>> getPageHelpers(final String route, final int page, final int pageSize);

  Future<bool> deleteHelper(String helperId);
}

class _HelperHttpService implements HelperService {
  final HelperRepository _helperRepository;

  _HelperHttpService(this._helperRepository);

  @override
  Future<Pageable<HelperEntity>> getPageHelpers(final String route, final int page, final int pageSize) {
    return this._helperRepository.getHelpers(route, page, pageSize);
  }

  @override
  Future<bool> deleteHelper(String helperId) {
    // TODO: implement deleteHelper
    throw UnimplementedError();
  }
}
