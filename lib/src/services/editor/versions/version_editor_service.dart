import 'package:flutter/cupertino.dart';
import 'package:palplugin/src/database/adapter/version_entity_adapter.dart';
import 'package:palplugin/src/database/entity/version_entity.dart';
import 'package:palplugin/src/database/repository/version_repository.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

abstract class VersionEditorService {

  factory VersionEditorService.build({
    @required VersionRepository versionRepository,
    @required PackageVersionReader packageVersionReader
  }) => VersionEditorHttpService(versionRepository, packageVersionReader);

  Future<VersionEntity> getCurrentVersion() => throw "not implemented yet";

  Future<List<VersionEntity>> getAll() => throw "not implemented yet";
}

class VersionEditorHttpService implements VersionEditorService {

  final VersionRepository versionRepository;
  final PackageVersionReader packageVersionReader;

  VersionEditorHttpService(this.versionRepository, this.packageVersionReader);

  @override
  Future<VersionEntity> getCurrentVersion() async {
    var currentVersion = packageVersionReader.version;
    return versionRepository.getVersions(name: currentVersion)
      .then((res) => res.numberOfElements > 0 ? res.entities.first : null);

  }

  @override
  Future<List<VersionEntity>> getAll() {
    return versionRepository.getVersions(pageSize: 1000)
      .then((res) => res.numberOfElements > 0 ? res.entities : List<VersionEntity>());
  }

}