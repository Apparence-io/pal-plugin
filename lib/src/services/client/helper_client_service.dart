import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/repository/helper_repository.dart';
import 'package:palplugin/src/database/repository/page_repository.dart';
import 'package:palplugin/src/database/repository/version_repository.dart';
import 'package:palplugin/src/injectors/user_app/user_app_context.dart';
import 'package:palplugin/src/services/package_version.dart';

class HelperClientService {

  factory HelperClientService.build(UserAppContext appContext) =>
    _HelperClientHttpService(
      appContext.helperRepository,
      appContext.pageRepository,
      PackageVersionReader()
    );

  Future<List<HelperEntity>> getPageHelpers(final String route, final String inAppUserId) => throw "not implemented";
}

class _HelperClientHttpService implements HelperClientService {

  final HelperRepository _helperRepository;

  final PageRepository _pageRepository;

  final PackageVersionReader _packageVersionReader;

  _HelperClientHttpService(this._helperRepository, this._pageRepository, this._packageVersionReader);

  @override
  Future<List<HelperEntity>> getPageHelpers(final String route, final String inAppUserId) async {
    var page = await _pageRepository.getPage(route);
    if(page == null || page.entities.length == 0) {
      return Future.value([]);
    }
    return _helperRepository.getClientHelpers(
      page.entities.first.id,
      _packageVersionReader.version,
      inAppUserId
    );
  }
}