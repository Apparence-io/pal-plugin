// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_user_visit_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HelperGroupUserVisitEntityAdapter
    extends TypeAdapter<HelperGroupUserVisitEntity> {
  @override
  final int typeId = 9;

  @override
  HelperGroupUserVisitEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelperGroupUserVisitEntity(
      pageId: fields[0] as String?,
      helperGroupId: fields[1] as String?,
      visitDate: fields[2] as DateTime?,
      visitVersion: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HelperGroupUserVisitEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.pageId)
      ..writeByte(1)
      ..write(obj.helperGroupId)
      ..writeByte(2)
      ..write(obj.visitDate)
      ..writeByte(3)
      ..write(obj.visitVersion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperGroupUserVisitEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
