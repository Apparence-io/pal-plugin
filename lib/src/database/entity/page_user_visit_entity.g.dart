// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_user_visit_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PageUserVisitEntityAdapter extends TypeAdapter<HelperGroupUserVisitEntity> {
  @override
  final int typeId = 9;

  @override
  HelperGroupUserVisitEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelperGroupUserVisitEntity(
      pageId: fields[0] as String,
      helperGroupId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HelperGroupUserVisitEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pageId)
      ..writeByte(1)
      ..write(obj.helperGroupId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageUserVisitEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
