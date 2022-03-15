// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_information.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginInformationAdapter extends TypeAdapter<LoginInformation> {
  @override
  final int typeId = 14;

  @override
  LoginInformation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginInformation(
      loginStatus: fields[0] as bool,
      sessionKey: fields[1] as String,
      moodleSessionKey: fields[2] as String,
      loginMsg: fields[3] as String,
      studentId: fields[4] as String,
      name: fields[5] as String,
      department: fields[6] as String,
      imgUrl: fields[7] as String,
      lastSyncTime: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginInformation obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.loginStatus)
      ..writeByte(1)
      ..write(obj.sessionKey)
      ..writeByte(2)
      ..write(obj.moodleSessionKey)
      ..writeByte(3)
      ..write(obj.loginMsg)
      ..writeByte(4)
      ..write(obj.studentId)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.department)
      ..writeByte(7)
      ..write(obj.imgUrl)
      ..writeByte(8)
      ..write(obj.lastSyncTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginInformationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
