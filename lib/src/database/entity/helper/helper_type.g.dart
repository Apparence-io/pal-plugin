// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helper_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HelperTypeAdapter extends TypeAdapter<HelperType> {
  @override
  final int typeId = 10;

  @override
  HelperType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HelperType.HELPER_FULL_SCREEN;
      case 1:
        return HelperType.SIMPLE_HELPER;
      case 2:
        return HelperType.ANCHORED_OVERLAYED_HELPER;
      case 3:
        return HelperType.UPDATE_HELPER;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, HelperType obj) {
    switch (obj) {
      case HelperType.HELPER_FULL_SCREEN:
        writer.writeByte(0);
        break;
      case HelperType.SIMPLE_HELPER:
        writer.writeByte(1);
        break;
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        writer.writeByte(2);
        break;
      case HelperType.UPDATE_HELPER:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
