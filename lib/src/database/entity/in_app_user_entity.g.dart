// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_user_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InAppUserEntityAdapter extends TypeAdapter<InAppUserEntity> {
  @override
  final int typeId = 12;

  @override
  InAppUserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InAppUserEntity(
      id: fields[0] as String?,
      inAppId: fields[1] as String?,
      disabledHelpers: fields[2] as bool?,
      anonymous: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, InAppUserEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.inAppId)
      ..writeByte(2)
      ..write(obj.disabledHelpers)
      ..writeByte(3)
      ..write(obj.anonymous);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppUserEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
