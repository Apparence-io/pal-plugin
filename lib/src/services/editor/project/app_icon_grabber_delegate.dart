import 'dart:io';
import 'dart:typed_data';

import 'package:application_icon/application_icon.dart';

class AppIconGrabberDelegate {
  Future<Uint8List> getClientAppIcon() async {
    return AppIconInfo.getAppIcon();
  }
}
