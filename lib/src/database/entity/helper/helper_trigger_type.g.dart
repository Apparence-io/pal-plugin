// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helper_trigger_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HelperTriggerTypeAdapter extends TypeAdapter<HelperTriggerType> {
  @override
  final int typeId = 11;

  @override
  HelperTriggerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HelperTriggerType.ON_SCREEN_VISIT;
      case 1:
        return HelperTriggerType.ON_NEW_UPDATE;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, HelperTriggerType obj) {
    switch (obj) {
      case HelperTriggerType.ON_SCREEN_VISIT:
        writer.writeByte(0);
        break;
      case HelperTriggerType.ON_NEW_UPDATE:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperTriggerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
