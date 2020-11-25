import 'package:pal/src/database/adapter/generic_adapter.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';

class HelperEntityAdapter extends GenericEntityAdapter<HelperEntity> {
  @override
  HelperEntity parseMap(Map<String, dynamic> map) {
    final HelperType helperType = getHelperType(map['type']);
    final HelperTriggerType helperTriggerType = getHelperTriggerType(map['triggerType']);
    return HelperEntity(
      id: map['id'],
      name: map['name'],
      type: helperType,
      triggerType: helperTriggerType,
      creationDate: map['creationDate'] != null ? DateTime.parse(map['creationDate']).toLocal() : null,
      lastUpdateDate: map['lastUpdateDate'] != null ? DateTime.parse(map['lastUpdateDate']).toLocal() : null,
      priority: map['priority'],
      versionMinId: map['versionMinId'],
      versionMin: map['versionMin'],
      versionMaxId: map['versionMaxId'],
      versionMax: map['versionMax'],
      helperBorders: map.containsKey('helperBorders') && map['helperBorders'] != null
        ? new HelperBorderEntityAdapter().parseDynamicArray(map['helperBorders']) : null,
      helperImages: map.containsKey('helperImages') && map['helperImages'] != null
        ? new HelperImageEntityAdapter().parseDynamicArray(map['helperImages']): null,
      helperTexts: map.containsKey('helperTexts') && map['helperTexts'] != null
        ? new HelperTextEntityAdapter().parseDynamicArray(map['helperTexts']) : null,
      helperBoxes: map.containsKey('helperBoxes') && map['helperBoxes'] != null
        ? new HelperBoxEntityAdapter().parseDynamicArray(map['helperBoxes']) : null,
    );
  }
}

class HelperBorderEntityAdapter extends GenericEntityAdapter<HelperBorderEntity> {
  @override
  HelperBorderEntity parseMap(Map<String, dynamic> map) {
    return HelperBorderEntity(
      id: map['id'],
      key: map['key'],
      color: map['color'],
      style: map['style'],
      width: map['width'],
    );
  }
}

class HelperImageEntityAdapter extends GenericEntityAdapter<HelperImageEntity> {
  @override
  HelperImageEntity parseMap(Map<String, dynamic> map) {
    return HelperImageEntity(
      id: map['id'],
      key: map['key'],
      url: map['url'],
    );
  }
}

class HelperTextEntityAdapter extends GenericEntityAdapter<HelperTextEntity> {
  @override
  HelperTextEntity parseMap(Map<String, dynamic> map) {
    return HelperTextEntity(
      id: map['id'],
      fontColor: map['fontColor'],
      fontFamily: map['fontFamily'],
      fontWeight: map['fontWeight'],
      key: map['key'],
      value: map['value'],
      fontSize: map['fontSize'],
    );
  }
}

class HelperBoxEntityAdapter extends GenericEntityAdapter<HelperBoxEntity> {
  @override
  HelperBoxEntity parseMap(Map<String, dynamic> map) {
    return HelperBoxEntity(
      id: map['id'],
      key: map['key'],
      backgroundColor: map['backgroundColor'],
    );
  }
}