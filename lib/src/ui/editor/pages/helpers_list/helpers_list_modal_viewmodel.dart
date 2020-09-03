import 'dart:typed_data';

import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';

class HelpersListModalModel extends MVVMModel {
  Uint8List imageBs;
  List<HelperEntity> helpers;
  bool isLoading;
  bool loadingMore;
  String pageId;
  bool noMore;

  HelpersListModalModel({
    this.helpers,
    this.isLoading,
    this.pageId,
  });
}