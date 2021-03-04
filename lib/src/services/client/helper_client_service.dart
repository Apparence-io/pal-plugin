import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/entity/page_user_visit_entity.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/page_user_visit_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/services/locale_service/locale_service.dart';

class HelperClientService {

  factory HelperClientService.build({
    HelperGroupUserVisitRepository localVisitRepository,
    HelperGroupUserVisitRepository remoteVisitRepository,
    ClientSchemaRepository clientSchemaRepository,
    ClientHelperRepository helperRemoteRepository,
    LocaleService userLocale,
  }) => _HelperClientService(
    clientSchemaRepository: clientSchemaRepository,
    helperRemoteRepository: helperRemoteRepository,
    localVisitRepository: localVisitRepository,
    remoteVisitRepository: remoteVisitRepository,
    userLocale: userLocale
  );

  Future<HelperGroupEntity> getPageNextHelper(final String route, final String inAppUserId) => throw "not implemented";

  Future onHelperTrigger(
    final String pageId, 
    final HelperGroupEntity helperGroup, 
    final HelperEntity helper, 
    final String inAppUserId, 
    final bool positiveFeedback) => throw "not implemented";
}

class _HelperClientService implements HelperClientService {

  final ClientSchemaRepository _clientSchemaRepository;

  final ClientHelperRepository _helperRemoteRepository;

  final HelperGroupUserVisitRepository _localVisitRepository, _remoteVisitRepository; // ignore: unused_field

  final LocaleService _userLocale;

  _HelperClientService({
    @required HelperGroupUserVisitRepository localVisitRepository,
    @required HelperGroupUserVisitRepository remoteVisitRepository,
    @required ClientSchemaRepository clientSchemaRepository,
    @required ClientHelperRepository helperRemoteRepository,
    @required LocaleService userLocale,
  }) : this._clientSchemaRepository = clientSchemaRepository,
       this._localVisitRepository = localVisitRepository,
       this._remoteVisitRepository = remoteVisitRepository,
       this._helperRemoteRepository = helperRemoteRepository,
       this._userLocale = userLocale;

  @override
  Future<HelperGroupEntity> getPageNextHelper(String route, String inAppUserId) async {
    SchemaEntity currentSchema = await _clientSchemaRepository.get();
    List<HelperGroupUserVisitEntity> userVisits = await _localVisitRepository.get(inAppUserId, null);
    List<HelperGroupEntity> group = currentSchema.groups
      .where((element) => element.page.route == route)
      .where((element) => userVisits.where((visit) => visit.helperGroupId == element.id).isEmpty)
      .toList();
    if(group.isNotEmpty) {
      group.sort();
      return group.first..helpers.sort();
    }
    return null;
  }

  @override
  Future onHelperTrigger(String pageId, HelperGroupEntity helperGroup, HelperEntity helper, String inAppUserId, bool positiveFeedback) async {
    try {
      var helperIndex = helperGroup.helpers.indexWhere((element) => element.id == helper.id);
      bool isLast = helperIndex == helperGroup.helpers.length - 1;
      var visit = HelperGroupUserVisitEntity(pageId: pageId, helperGroupId: helperGroup.id);
      await _remoteVisitRepository.add(visit, 
        isLast: isLast,
        feedback: positiveFeedback, 
        inAppUserId: inAppUserId,
        helper: helper,
        languageCode: _userLocale.languageCode
      );
      await _localVisitRepository.add(visit); // we only store locally that he already visited
    } catch(err) {
      print("error occured while sending visits ");
      print(err);
    }
  }

}