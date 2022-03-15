// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoStatusAdapter extends TypeAdapter<TodoStatus> {
  @override
  final int typeId = 5;

  @override
  TodoStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TodoStatus.done;
      case 1:
        return TodoStatus.undone;
      case 2:
        return TodoStatus.doing;
      default:
        return TodoStatus.done;
    }
  }

  @override
  void write(BinaryWriter writer, TodoStatus obj) {
    switch (obj) {
      case TodoStatus.done:
        writer.writeByte(0);
        break;
      case TodoStatus.undone:
        writer.writeByte(1);
        break;
      case TodoStatus.doing:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
