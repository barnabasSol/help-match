// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      name: fields[1] as String,
      username: fields[2] as String,
      email: fields[3] as String,
      profilePicUrl: fields[4] as String,
      isActivated: fields[5] as bool,
      isOnline: fields[6] as bool,
      interests: (fields[7] as List?)?.cast<String>(),
      createdAt: fields[8] as DateTime,
      version: (fields[9] as num).toInt(),
      orgInfo: fields[10] as OrgInfo?,
      role: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.profilePicUrl)
      ..writeByte(5)
      ..write(obj.isActivated)
      ..writeByte(6)
      ..write(obj.isOnline)
      ..writeByte(7)
      ..write(obj.interests)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.version)
      ..writeByte(10)
      ..write(obj.orgInfo)
      ..writeByte(11)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrgInfoAdapter extends TypeAdapter<OrgInfo> {
  @override
  final int typeId = 2;

  @override
  OrgInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrgInfo(
      orgId: fields[0] as String,
      name: fields[1] as String,
      profileIcon: fields[2] as String,
      description: fields[3] as String,
      location: fields[4] as Location,
      isVerified: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      type: fields[7] as String,
      version: (fields[8] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, OrgInfo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.orgId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.profileIcon)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.isVerified)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrgInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocationAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 3;

  @override
  Location read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Location(
      latitude: (fields[0] as num).toDouble(),
      longitude: (fields[1] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
