import 'package:flutter/cupertino.dart';
import 'package:pal/src/database/entity/version_entity.dart';
import 'package:pal/src/database/repository/version_repository.dart';
import 'package:pal/src/services/package_version.dart';

abstract class VersionEditorService {
  factory VersionEditorService.build(
          {@required VersionRepository versionRepository,
          @required PackageVersionReader packageVersionReader}) =>
      VersionEditorHttpService(versionRepository, packageVersionReader);

  Future<VersionEntity> getCurrentVersion() => throw "not implemented yet";
  Future<List<VersionEntity>> getAll() => throw "not implemented yet";
  Future<VersionEntity> getVersion(String name) => throw "not implemented yet";
  Future<VersionEntity> createVersion(VersionEntity version) =>
      throw "not implemented yet";
  Future<int> getOrCreateVersionId(String versionName) =>
      throw "not implemented yet";
}

class VersionEditorHttpService implements VersionEditorService {
  final VersionRepository versionRepository;
  final PackageVersionReader packageVersionReader;

  VersionEditorHttpService(this.versionRepository, this.packageVersionReader);

  @override
  Future<VersionEntity> getCurrentVersion() async {
    var currentVersion = packageVersionReader.version;
    return versionRepository
        .getVersions(name: currentVersion)
        .then((res) => res.numberOfElements > 0 ? res.entities.first : null);
  }

  @override
  Future<List<VersionEntity>> getAll() {
    return versionRepository.getVersions(pageSize: 1000).then((res) =>
        res.numberOfElements > 0 ? res.entities : List<VersionEntity>());
  }

  @override
  Future<VersionEntity> getVersion(String name) {
    return versionRepository.getVersion(name: name);
  }

  @override
  Future<VersionEntity> createVersion(VersionEntity createVersion) {
    return versionRepository.createVersion(createVersion);
  }

  @override
  Future<int> getOrCreateVersionId(String versionName) async {
    if (versionName == null || versionName.length <= 0) {
      throw 'invalid version name';
    }

    int versionMinId;
    VersionEntity resVersion = await this.getVersion(versionName);
    if (resVersion?.id != null) {
      versionMinId = resVersion.id;
    } else {
      VersionEntity resVersion = await this.createVersion(
        VersionEntity(name: versionName),
      );
      if (resVersion?.id != null) {
        versionMinId = resVersion?.id;
      } else {
        throw 'page id is null';
      }
    }

    return versionMinId;
  }
}
