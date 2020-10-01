import 'package:package_info/package_info.dart';

// FIXME: Call await PackageVersionReader.init() before use
// to ensure init was ok
class PackageVersionReader {
  PackageInfo info;

  Future<void> init() async {
    info = await PackageInfo.fromPlatform();
  }

  String get version => info.version;
}
