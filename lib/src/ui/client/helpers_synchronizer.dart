import 'package:flutter/material.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/page_user_visit_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/services/editor/versions/version_editor_service.dart';
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
    String currentVersion = packageVersionReader.version;
    var currentSchema = await schemaLocalRepository.get(appVersion: currentVersion);
    var lastSchemaVersion = await schemaRemoteRepository.get(
      schemaVersion: currentSchema?.schemaVersion,
      appVersion: currentVersion
    );
    if(currentSchema == null) {
      var visits = await pageUserVisitRemoteRepository.get(inAppUserId, currentVersion);
      await pageUserVisitLocalRepository.save(visits);
    }
    if(lastSchemaVersion != null) {
      await schemaLocalRepository.save(lastSchemaVersion);
    }
  }

}