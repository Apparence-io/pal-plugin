// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PageEntityAdapter extends TypeAdapter<PageEntity> {
  @override
  final int typeId = 8;

  @override
  PageEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PageEntity(
      id: fields[0] as String,
      creationDate: fields[1] as DateTime,
      lastUpdateDate: fields[2] as DateTime,
      route: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PageEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.creationDate)
      ..writeByte(2)
      ..write(obj.lastUpdateDate)
      ..writeByte(3)
      ..write(obj.route);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
