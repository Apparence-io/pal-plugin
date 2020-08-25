import 'dart:typed_data';

import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';

class HelpersListModalModel extends MVVMModel {
  Uint8List imageBs;
  List<HelperEntity> helpers;
  bool isLoading = true;

  HelpersListModalModel({
    this.helpers,
    this.isLoading,
  });
}