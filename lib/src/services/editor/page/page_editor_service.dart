import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/database/repository/page_repository.dart';

abstract class PageEditorService {
  factory PageEditorService.build(
          GlobalKey? repaintBoundaryKey, PageRepository pageRepository) =>
      _PageEditorHttpService(repaintBoundaryKey, pageRepository);

  Future capturePagePreview();
  Future<PageEntity?> getPage(String route);
  Future<PageEntity> createPage(PageEntity createPage);
  Future<String?> getOrCreatePageId(String? routeName);
}

class _PageEditorHttpService implements PageEditorService {
  final GlobalKey? _repaintBoundaryKey;
  final PageRepository _pageRepository;

  _PageEditorHttpService(this._repaintBoundaryKey, this._pageRepository);

  @override
  Future capturePagePreview({double pixelRatio = 3.0}) async {
    try {
      RenderRepaintBoundary boundary =
          _repaintBoundaryKey!.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData byteData =
          await (image.toByteData(format: ui.ImageByteFormat.png) as Future<ByteData>);
      Uint8List data = byteData.buffer.asUint8List();
      List<int> dataList = data.toList();
      // TODO: Send with repository using multipart image
    } catch (e,s) {
      debugPrint('error while catching screenshot');
      print(e);
      print(s);
    }
  }

  @override
  Future<PageEntity?> getPage(String route) {
    return this._pageRepository.getPage(route);
  }

  @override
  Future<PageEntity> createPage(PageEntity createPage) {
    return this._pageRepository.createPage(createPage);
  }

  @override
  Future<String?> getOrCreatePageId(String? routeName) async {
    if (routeName == null || routeName.length <= 0) {
      throw 'invalid route name';
    }
    PageEntity? resPage = await this.getPage(routeName);
    if(resPage == null || resPage.id!.length == 0) {
      resPage = await this.createPage(
        PageEntity(route: routeName),
      );
      if(resPage.id == null)
        throw 'page id is null';
    } 
    return resPage.id;
  }
}
