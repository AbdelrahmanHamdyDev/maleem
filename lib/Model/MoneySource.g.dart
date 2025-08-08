// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MoneySource.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoneySourceAdapter extends TypeAdapter<MoneySource> {
  @override
  final int typeId = 3;

  @override
  MoneySource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoneySource(
      name: fields[0] as String,
      amount: fields[1] as double,
      colorValue: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MoneySource obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneySourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
