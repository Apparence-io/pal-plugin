import 'package:palplugin/src/database/entity/page_entity.dart';
import 'package:palplugin/src/database/repository/page_repository.dart';

abstract class PageClientService {

  factory PageClientService.build(PageRepository pageRepository) => _PageClientHttpService(pageRepository);

  Future<PageEntity> getPage(final String route);
}

class _PageClientHttpService implements PageClientService {
  final PageRepository _pageRepository;

  _PageClientHttpService(this._pageRepository);

  @override
  Future<PageEntity> getPage(String route) {
    return this._pageRepository.getPage(route);
  }
}
