// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helper_group_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HelperGroupEntityAdapter extends TypeAdapter<HelperGroupEntity> {
  @override
  final int typeId = 2;

  @override
  HelperGroupEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelperGroupEntity(
      id: fields[0] as String?,
      priority: fields[1] as int?,
      helpers: (fields[2] as List?)?.cast<HelperEntity>(),
      page: fields[3] as PageEntity?,
      name: fields[4] as String?,
      triggerType: fields[5] as HelperTriggerType?,
      creationDate: fields[6] as DateTime?,
      minVersion: fields[7] as String?,
      maxVersion: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HelperGroupEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.priority)
      ..writeByte(2)
      ..write(obj.helpers)
      ..writeByte(3)
      ..write(obj.page)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.triggerType)
      ..writeByte(6)
      ..write(obj.creationDate)
      ..writeByte(7)
      ..write(obj.minVersion)
      ..writeByte(8)
      ..write(obj.maxVersion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperGroupEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
