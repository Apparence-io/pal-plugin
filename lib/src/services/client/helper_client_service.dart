import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/entity/page_user_visit_entity.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/page_user_visit_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';

class HelperClientService {

  factory HelperClientService.build({
    HelperGroupUserVisitRepository localVisitRepository,
    HelperGroupUserVisitRepository remoteVisitRepository,
    ClientSchemaRepository clientSchemaRepository,
    ClientHelperRepository helperRemoteRepository
  }) => _HelperClientService(
    clientSchemaRepository: clientSchemaRepository,
    helperRemoteRepository: helperRemoteRepository,
    localVisitRepository: localVisitRepository,
    remoteVisitRepository: remoteVisitRepository
  );

  Future<HelperGroupEntity> getPageNextHelper(final String route, final String inAppUserId) => throw "not implemented";

  Future onHelperTrigger(final String pageId, final HelperGroupEntity helperGroup, final String inAppUserId, final bool positiveFeedback) => throw "not implemented";
}

class _HelperClientService implements HelperClientService {

  final ClientSchemaRepository _clientSchemaRepository;

  final ClientHelperRepository _helperRemoteRepository;

  final HelperGroupUserVisitRepository _localVisitRepository, _remoteVisitRepository; // ignore: unused_field

  _HelperClientService({
    @required HelperGroupUserVisitRepository localVisitRepository,
    @required HelperGroupUserVisitRepository remoteVisitRepository,
    @required ClientSchemaRepository clientSchemaRepository,
    @required ClientHelperRepository helperRemoteRepository
  }) : this._clientSchemaRepository = clientSchemaRepository,
       this._localVisitRepository = localVisitRepository,
       this._remoteVisitRepository = remoteVisitRepository,
       this._helperRemoteRepository = helperRemoteRepository;

  @override
  Future<HelperGroupEntity> getPageNextHelper(String route, String inAppUserId) async {
    SchemaEntity currentSchema = await _clientSchemaRepository.get();
    List<HelperGroupUserVisitEntity> userVisits = await _localVisitRepository.get(inAppUserId, null);
    List<HelperGroupEntity> group = currentSchema.groups
      .where((element) => element.page.route == route)
      .where((element) => userVisits.where((visit) => visit.helperGroupId == element.id).isEmpty)
      .toList();
    if(group.isNotEmpty) {
      group.sort((a,b) => a.priority < b.priority ? -1 : 1);
      return group.last;
    }
    return null;
  }

  @override
  Future onHelperTrigger(String pageId, HelperGroupEntity helperGroup, String inAppUserId, bool positiveFeedback) async {
    try {
      var visit = HelperGroupUserVisitEntity(pageId: pageId, helperGroupId: helperGroup.id);
      await _remoteVisitRepository.add(visit, feedback: positiveFeedback, inAppUserId: inAppUserId);
      await _localVisitRepository.add(visit); // we only store locally that he already visited
    } catch(err) {
      print("error occured while sending visits");
    }
  }

}