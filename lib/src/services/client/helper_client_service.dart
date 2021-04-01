import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';
import 'package:pal/src/database/entity/page_user_visit_entity.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/page_user_visit_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/services/client/versions/version.dart';
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

  Future<HelperGroupEntity> getPageNextHelper(
    final String route, 
    final String inAppUserId, 
    final AppVersion appVersion) => throw "not implemented";

  Future onHelperTrigger(
    final String pageId, 
    final HelperGroupEntity helperGroup, 
    final HelperEntity helper, 
    final String inAppUserId, 
    final bool positiveFeedback,
    final String inAppVersion) => throw "not implemented";
}

class _HelperClientService implements HelperClientService {

  final ClientSchemaRepository _clientSchemaRepository;

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
       this._userLocale = userLocale;

  @override
  Future<HelperGroupEntity> getPageNextHelper(
    String route, 
    String inAppUserId, 
    AppVersion inAppVersion
  ) async {
    SchemaEntity currentSchema = await _clientSchemaRepository.get();
    List<HelperGroupUserVisitEntity> userVisits = await _localVisitRepository.get(inAppUserId, null);
    List<HelperGroupEntity> group = currentSchema.groups
      .where((element) => element.page.route == route)
      .where((element) => inAppVersion.isGreaterOrEqual(AppVersion.fromString(element.minVersion)))
      .where((element) => inAppVersion.isLowerOrEqual(AppVersion.fromString(element.maxVersion)))
      .where((element) => userVisits.where((visit) => visit.helperGroupId == element.id).isEmpty)
      .toList();
    if(group.isNotEmpty) {
      group.sort();
      var firstVisit = userVisits.isNotEmpty ? userVisits.first : null;
      var firstVisitVersion = userVisits.isNotEmpty ? AppVersion.fromString(firstVisit?.visitVersion) : null;
      int i = -1;
      HelperGroupEntity selectedGroup;
      while(i < group.length - 1 && selectedGroup == null) {
        i++;
        if(group[i].triggerType == HelperTriggerType.ON_NEW_UPDATE 
          && (firstVisit == null || firstVisitVersion.isLower(inAppVersion))) {
          selectedGroup = group[i];
        } else if (group[i].triggerType == HelperTriggerType.ON_SCREEN_VISIT) {
          selectedGroup = group[i];
        }
      } 
      if(selectedGroup!=null)
        return selectedGroup..helpers.sort();
    }
    return null;
  }

  @override
  Future onHelperTrigger(
    String pageId, 
    HelperGroupEntity helperGroup, 
    HelperEntity helper, 
    String inAppUserId, 
    bool positiveFeedback, 
    String inAppVersion
  ) async {
    try {
      var helperIndex = helperGroup.helpers.indexWhere((element) => element.id == helper.id);
      bool isLast = helperIndex == helperGroup.helpers.length - 1;
      var visit = HelperGroupUserVisitEntity(
        pageId: pageId, 
        helperGroupId: helperGroup.id,
        visitDate: DateTime.now(),
        visitVersion: inAppVersion
      );
      await _remoteVisitRepository.add(
        visit, 
        isLast: isLast,
        feedback: positiveFeedback, 
        inAppUserId: inAppUserId,
        helper: helper,
        languageCode: _userLocale.languageCode,

      );
      await _localVisitRepository.add(visit); // we only store locally that he already visited
    } catch(err) {
      print("error occured while sending visits ");
      print(err);
    }
  }


}