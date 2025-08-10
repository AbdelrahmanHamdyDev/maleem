// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExpenseGroup.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseGroupAdapter extends TypeAdapter<ExpenseGroup> {
  @override
  final int typeId = 1;

  @override
  ExpenseGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseGroup(
      name: fields[0] as String,
      notes: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseGroup obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
