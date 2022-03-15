// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizTodoAdapter extends TypeAdapter<QuizTodo> {
  @override
  final int typeId = 1;

  @override
  QuizTodo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizTodo(
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
  void write(BinaryWriter writer, QuizTodo obj) {
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
      other is QuizTodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
