import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/services/helper_service.dart';

class EditorLoader {
  final HelperService _helperService;
  EditorLoader(this._helperService);

  Future<HelperEntity> saveHelper({
    @required String name,
    @required String triggerType,
    @required int priority,
    @required int versionMinId,
    @required int versionMaxId,
    @required String pageId,
    @required CreateHelperEntity helperEntity,
  }) {
    // General info
    helperEntity.name = name;
    helperEntity.triggerType = triggerType;
    helperEntity.priority = priority;
    helperEntity.versionMinId = versionMinId;
    helperEntity.versionMaxId = versionMaxId;

    return this._helperService.createPageHelper(pageId, helperEntity);
  }
}
