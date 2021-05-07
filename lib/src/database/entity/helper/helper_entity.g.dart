// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helper_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HelperEntityAdapter extends TypeAdapter<HelperEntity> {
  @override
  final int typeId = 3;

  @override
  HelperEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelperEntity(
      id: fields[0] as String?,
      name: fields[3] as String?,
      type: fields[5] as HelperType?,
      triggerType: fields[6] as HelperTriggerType?,
      creationDate: fields[1] as DateTime?,
      lastUpdateDate: fields[2] as DateTime?,
      priority: fields[4] as int?,
      helperBorders: (fields[11] as List?)?.cast<HelperBorderEntity>(),
      helperImages: (fields[12] as List?)?.cast<HelperImageEntity>(),
      helperTexts: (fields[13] as List?)?.cast<HelperTextEntity>(),
      helperBoxes: (fields[14] as List?)?.cast<HelperBoxEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, HelperEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.creationDate)
      ..writeByte(2)
      ..write(obj.lastUpdateDate)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.triggerType)
      ..writeByte(11)
      ..write(obj.helperBorders)
      ..writeByte(12)
      ..write(obj.helperImages)
      ..writeByte(13)
      ..write(obj.helperTexts)
      ..writeByte(14)
      ..write(obj.helperBoxes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HelperBorderEntityAdapter extends TypeAdapter<HelperBorderEntity> {
  @override
  final int typeId = 4;

  @override
  HelperBorderEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelperBorderEntity(
      id: fields[0] as int?,
      color: fields[1] as String?,
      key: fields[2] as String?,
      style: fields[3] as String?,
      width: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, HelperBorderEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.key)
      ..writeByte(3)
      ..write(obj.style)
      ..writeByte(4)
      ..write(obj.width);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperBorderEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HelperImageEntityAdapter extends TypeAdapter<HelperImageEntity> {
  @override
  final int typeId = 5;

  @override
  HelperImageEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelperImageEntity(
      id: fields[0] as int?,
      key: fields[1] as String?,
      url: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HelperImageEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.key)
      ..writeByte(2)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperImageEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HelperTextEntityAdapter extends TypeAdapter<HelperTextEntity> {
  @override
  final int typeId = 6;

  @override
  HelperTextEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelperTextEntity(
      id: fields[0] as int?,
      fontColor: fields[1] as String?,
      fontFamily: fields[2] as String?,
      fontWeight: fields[3] as String?,
      key: fields[4] as String?,
      value: fields[5] as String?,
      fontSize: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HelperTextEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fontColor)
      ..writeByte(2)
      ..write(obj.fontFamily)
      ..writeByte(3)
      ..write(obj.fontWeight)
      ..writeByte(4)
      ..write(obj.key)
      ..writeByte(5)
      ..write(obj.value)
      ..writeByte(6)
      ..write(obj.fontSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperTextEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HelperBoxEntityAdapter extends TypeAdapter<HelperBoxEntity> {
  @override
  final int typeId = 7;

  @override
  HelperBoxEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelperBoxEntity(
      id: fields[0] as int?,
      backgroundColor: fields[1] as String?,
      key: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HelperBoxEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.backgroundColor)
      ..writeByte(2)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelperBoxEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
