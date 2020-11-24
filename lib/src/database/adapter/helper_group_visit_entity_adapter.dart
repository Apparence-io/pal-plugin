import 'package:pal/src/database/entity/page_user_visit_entity.dart';
import 'package:pal/src/database/entity/version_entity.dart';

import 'generic_adapter.dart';

class HelperGroupUserVisitEntityAdapter extends GenericEntityAdapter<HelperGroupUserVisitEntity> {
  @override
  HelperGroupUserVisitEntity parseMap(Map<String, dynamic> map) {
    return HelperGroupUserVisitEntity(
      helperGroupId: map["helperGroupId"],
      pageId: map["pageId"],
    );
  }
}