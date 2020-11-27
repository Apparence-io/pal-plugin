// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchemaEntityAdapter extends TypeAdapter<SchemaEntity> {
  @override
  final int typeId = 0;

  @override
  SchemaEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchemaEntity(
      projectId: fields[0] as String,
      groups: (fields[1] as List)?.cast<HelperGroupEntity>(),
      schemaVersion: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SchemaEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.projectId)
      ..writeByte(1)
      ..write(obj.groups)
      ..writeByte(2)
      ..write(obj.schemaVersion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchemaEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
