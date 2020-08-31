import 'package:package_info/package_info.dart';

class PackageVersionReader {

  PackageInfo info;

  PackageVersionReader() {
    this._init();
  }

  Future<void> _init() async {
    info = await PackageInfo.fromPlatform();
  }

  String get version => info.version;

}