import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

abstract class PageEditorService {
  factory PageEditorService.build(GlobalKey repaintBoundaryKey) =>
      _PageEditorHttpService(repaintBoundaryKey);

  Future capturePagePreview();
}

class _PageEditorHttpService implements PageEditorService {
  final GlobalKey _repaintBoundaryKey;

  _PageEditorHttpService(this._repaintBoundaryKey);

  @override
  Future capturePagePreview({double pixelRatio = 3.0}) async {
    try {
      RenderRepaintBoundary boundary =
          _repaintBoundaryKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List data = byteData.buffer.asUint8List();
      List<int> dataList = data.toList();

      print(dataList);
      // TODO: Send with repository using multipart image
    } catch (e) {
      print('error while catching screenshot');
      print(e);
    }
  }
}
