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
      priority: fields[0] as int,
      helpers: (fields[1] as List)?.cast<HelperEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, HelperGroupEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.priority)
      ..writeByte(1)
      ..write(obj.helpers);
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
