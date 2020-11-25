import 'package:flutter/material.dart';
import 'package:pal/src/database/repository/client/page_user_visit_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/services/package_version.dart';

class HelpersSynchronizer {

  final HelperGroupUserVisitRepository pageUserVisitRemoteRepository, pageUserVisitLocalRepository;

  final ClientSchemaRepository schemaRemoteRepository;
  
  final ClientSchemaLocalRepository schemaLocalRepository;

  final PackageVersionReader packageVersionReader;

  HelpersSynchronizer({
    @required this.pageUserVisitRemoteRepository,
    @required this.pageUserVisitLocalRepository,
    @required this.schemaRemoteRepository,
    @required this.schemaLocalRepository,
    @required this.packageVersionReader,
  });

  Future<void> sync(String inAppUserId) async {
    debugPrint("...sync database start");
    String currentVersion = packageVersionReader.version;
    var currentSchema = await schemaLocalRepository.get(appVersion: currentVersion);
    var lastSchemaVersion = await schemaRemoteRepository.get(
      schemaVersion: currentSchema?.schemaVersion,
      appVersion: currentVersion
    );
    debugPrint(" current schema version ${currentSchema?.schemaVersion}");
    debugPrint(" remote schema version ${lastSchemaVersion?.schemaVersion}");
    if(currentSchema == null) {
      var visits = await pageUserVisitRemoteRepository.get(inAppUserId, currentVersion);
      debugPrint("Save user visits");
      debugPrint(" ${visits.length} visits found");
      await pageUserVisitLocalRepository.save(visits);
    }
    if(lastSchemaVersion != null) {
      debugPrint("${lastSchemaVersion?.groups?.length ?? 0} groups saved");
      await schemaLocalRepository.save(lastSchemaVersion);
    }
    debugPrint("...sync database end");
  }

}