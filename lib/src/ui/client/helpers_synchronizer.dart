import 'package:flutter/material.dart';
import 'package:pal/src/database/repository/client/helper_repository.dart';
import 'package:pal/src/database/repository/client/schema_repository.dart';
import 'package:pal/src/services/editor/versions/version_editor_service.dart';
import 'package:pal/src/services/package_version.dart';

class HelpersSynchronizer {

  final ClientSchemaRepository remoteRepository;
  
  final ClientSchemaLocalRepository localRepository;

  final PackageVersionReader packageVersionReader;

  HelpersSynchronizer({
    @required this.remoteRepository,
    @required this.localRepository,
    @required this.packageVersionReader
  });

  Future<void> sync() async {
    String currentVersion = packageVersionReader.version;
    var currentSchema = await localRepository.get(appVersion: currentVersion);
    var lastSchemaVersion = await remoteRepository.get(
      schemaVersion: currentSchema?.schemaVersion,
      appVersion: currentVersion
    );
    if(lastSchemaVersion != null) {
      await localRepository.save(lastSchemaVersion);
    }
  }

}