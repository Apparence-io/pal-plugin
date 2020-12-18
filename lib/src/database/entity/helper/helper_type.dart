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

HelperType getHelperType(final String value) {
  return HelperType.values
      .firstWhere((element) => element.toString().split('.')[1] == value);
}

String helperTypeToString(final HelperType helperType) {
  return helperType.toString().split('.')[1];
}

String getHelperTypeDescription(final HelperType helperType) {
  String description;
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
