import 'package:pal/src/database/adapter/generic_adapter.dart';
import 'package:pal/src/database/entity/in_app_user_entity.dart';

class InAppUserEntityAdapter extends GenericEntityAdapter<InAppUserEntity> {
  @override
  InAppUserEntity parseMap(Map<String, dynamic> map) {
    return InAppUserEntity(
      id: map["id"],
      inAppId: map["inAppId"],
      anonymous: map["anonymous"],
      disabledHelpers: map["disabledHelpers"],
    );
  }
}
