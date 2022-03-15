// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vod_todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VodTodoAdapter extends TypeAdapter<VodTodo> {
  @override
  final int typeId = 3;

  @override
  VodTodo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VodTodo(
      index: fields[0] as int,
      id: fields[1] as String,
      title: fields[2] as String,
      courseId: fields[3] as String,
      dueDate: fields[4] as DateTime,
      availability: fields[5] as bool,
      iconUrl: fields[6] as String,
      status: fields[7] as TodoStatus,
    );
  }

  @override
  void write(BinaryWriter writer, VodTodo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.courseId)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.availability)
      ..writeByte(6)
      ..write(obj.iconUrl)
      ..writeByte(7)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VodTodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
