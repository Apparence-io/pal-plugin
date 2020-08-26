import 'package:palplugin/src/database/entity/page_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/page_repository.dart';

abstract class PageService {
  factory PageService.build(PageRepository pageRepository) =>
      _PageHttpService(pageRepository);

  Future<PageEntity> createPage(final PageEntity createPage);
  Future<Pageable<PageEntity>> getPage(final String route);
  Future<Pageable<PageEntity>> getPages();
}

class _PageHttpService implements PageService {
  final PageRepository _pageRepository;

  _PageHttpService(this._pageRepository);

  @override
  Future<PageEntity> createPage(PageEntity createPage) {
    return this._pageRepository.createPage(createPage);
  }

  @override
  Future<Pageable<PageEntity>> getPages() {
    return this._pageRepository.getPages();
  }

  @override
  Future<Pageable<PageEntity>> getPage(String route) {
    return this._pageRepository.getPage(route);
  }
}
