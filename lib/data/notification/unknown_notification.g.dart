// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unknown_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnknownNotificationAdapter extends TypeAdapter<UnknownNotification> {
  @override
  final int typeId = 10;

  @override
  UnknownNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnknownNotification(
      title: fields[0] as String,
      body: fields[1] as String,
      url: fields[2] as String,
      time: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UnknownNotification obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnknownNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
