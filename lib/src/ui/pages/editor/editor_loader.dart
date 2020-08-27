import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/services/helper_service.dart';

class EditorLoader {
  final HelperService _helperService;
  EditorLoader(this._helperService);

  Future<HelperEntity> saveHelper(
    String pageId,
    CreateHelperEntity helperEntity,
  ) {
    // General info
    helperEntity.name = 'Un nom';
    helperEntity.triggerType = 'HELPER_FULL_SCREEN';
    helperEntity.priority = 0;
    helperEntity.versionMinId = 1;
    helperEntity.versionMaxId = 2;

    return this._helperService.createPageHelper(pageId, helperEntity);
  }
}
