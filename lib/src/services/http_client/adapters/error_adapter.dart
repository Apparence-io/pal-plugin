
import 'package:pal/src/database/adapter/generic_adapter.dart';

class ErrorAdapter extends GenericEntityAdapter {
  @override
  parseMap(Map<String, dynamic>? map) {
    if (map == null && !map!.containsValue('message')) {
      return null;
    }

    return map['message'];
  }
}
