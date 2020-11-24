import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/database/repository/page_repository.dart';
import 'package:pal/src/injectors/user_app/user_app_context.dart';
import 'package:pal/src/services/package_version.dart';

class HelperClientService {

  factory HelperClientService.build({ClientSchemaRepository clientSchemaRepository, ClientHelperRepository helperRemoteRepository})
    => _HelperClientService(clientSchemaRepository: clientSchemaRepository, helperRemoteRepository: helperRemoteRepository);


  Future<List<HelperEntity>> getPageHelpers(final String route, final String inAppUserId) => throw "not implemented";

  Future<HelperGroupEntity> getPageNextHelper(final String route, final String inAppUserId) => throw "not implemented";

  Future triggerHelper(final String pageId, final String helperId, final String inAppUserId, final bool positiveFeedback) => throw "not implemented";
}

class _HelperClientHttpService implements HelperClientService {

  final ClientHelperRepository _helperRepository;

  final PageRepository _pageRepository;

  final PackageVersionReader _packageVersionReader;

  _HelperClientHttpService(this._helperRepository, this._pageRepository, this._packageVersionReader);

  @override
  @deprecated
  Future<List<HelperEntity>> getPageHelpers(final String route, final String inAppUserId) async {
    var page = await _pageRepository.getClientPage(route);
    if(page == null || page.entities.length == 0) {
      return Future.value([]);
    }
    await _packageVersionReader.init();
    return _helperRepository.getClientHelpers(
      page.entities.first.id,
      _packageVersionReader.version,
      inAppUserId
    );
  }

  @override
  Future triggerHelper(final String pageId, final String helperId, final String inAppUserId, final bool positiveFeedback) {
    return this._helperRepository.clientTriggerHelper(pageId, helperId, inAppUserId, positiveFeedback);
  }

  @override
  Future<HelperGroupEntity> getPageNextHelper(String route, String inAppUserId) {
    // TODO: implement getPageNextHelper
    throw UnimplementedError();
  }
}

class _HelperClientService implements HelperClientService {

  final ClientSchemaRepository _clientSchemaRepository;

  final ClientHelperRepository _helperRemoteRepository;

  _HelperClientService({
    @required ClientSchemaRepository clientSchemaRepository,
    @required ClientHelperRepository helperRemoteRepository
  }) : this._clientSchemaRepository = clientSchemaRepository,
       this._helperRemoteRepository = helperRemoteRepository;

  @override
  Future<HelperGroupEntity> getPageNextHelper(String route, String inAppUserId) async {
    SchemaEntity currentSchema = await _clientSchemaRepository.get();
    //FIXME check user has not see it from a localstorage visits
    List<HelperGroupEntity> group = currentSchema.groups
      .where((element) => element.page.route == route)
      .toList();
    if(group.isNotEmpty) {
      group.sort((a,b) => a.priority < b.priority ? -1 : 1);
      return group.last;
    }
    return null;
  }

  @override
  Future triggerHelper(String pageId, String helperId, String inAppUserId, bool positiveFeedback)
    => _helperRemoteRepository.clientTriggerHelper(pageId, helperId, inAppUserId, positiveFeedback);

  @override
  @deprecated
  Future<List<HelperEntity>> getPageHelpers(String route, String inAppUserId) {
    // TODO: implement getPageHelpers
    throw UnimplementedError();
  }

}