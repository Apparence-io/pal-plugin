import 'package:hive/hive.dart';

part 'helper_type.g.dart';

@HiveType(typeId : 10)
enum HelperType {

  @HiveField(0)
  HELPER_FULL_SCREEN,

  @HiveField(1)
  SIMPLE_HELPER,

  @HiveField(2)
  ANCHORED_OVERLAYED_HELPER,

  @HiveField(3)
  UPDATE_HELPER,
}

HelperType getHelperType(final String? value) {
  return HelperType.values
      .firstWhere((element) => element.toString().split('.')[1] == value);
}

String helperTypeToString(final HelperType helperType) {
  return helperType.toString().split('.')[1];
}

String? helperTypeToAsset(final HelperType? helperType) {
  String? asset;
  switch (helperType) {
    case HelperType.HELPER_FULL_SCREEN:
      asset = 'helper_type_fullscreen.png';
      break;
    case HelperType.UPDATE_HELPER:
      asset = 'helper_type_update.png';
      break;
    case HelperType.SIMPLE_HELPER:
      asset = 'helper_type_simple.png';
      break;
    case HelperType.ANCHORED_OVERLAYED_HELPER:
      asset = 'helper_type_anchored.png';
      break;  
    default:
  }
  return asset;
}

String? getHelperTypeDescription(final HelperType? helperType) {
  String? description;
  switch (helperType) {
    case HelperType.HELPER_FULL_SCREEN:
      description = 'Fullscreen';
      break;
    case HelperType.UPDATE_HELPER:
      description = 'Update overlay';
      break;
    case HelperType.SIMPLE_HELPER:
      description = 'Overlayed bottom';
      break;
    case HelperType.ANCHORED_OVERLAYED_HELPER:
      description = 'Anchored';
      break;  
    default:
  }
  return description;
}
