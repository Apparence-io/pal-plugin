import 'dart:typed_data';

// import 'package:application_icon/application_icon.dart';

class AppIconGrabberDelegate {
  Future<Uint8List> getClientAppIcon() async {
    // FIXME: Remove this to enable application icon on multiple platforms
    return Uint8List(0);
    // return AppIconInfo.getAppIcon();
  }
}
