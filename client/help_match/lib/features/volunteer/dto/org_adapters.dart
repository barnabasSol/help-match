import 'package:help_match/core/box_types/box_types.dart';
import 'package:help_match/features/volunteer/dto/org_dto.dart';
import 'package:hive_ce/hive.dart';

class OrgDtoAdapter extends TypeAdapter<OrgDto> {
  @override
  final int typeId = BoxTypes.ORG_DETAIL;

  @override
  OrgDto read(BinaryReader reader) {
    return OrgDto(
      id: reader.read(),
      name: reader.read(),
      userId: reader.read(),
      profileIcon: reader.read(),
      description: reader.read(),
      proximity: reader.read(),
      location: reader.read(),
      isVerified: reader.read(),
      createdAt: reader.read(),
      type: reader.read(),
      jobs: (reader.read() as List?)?.cast<JobViewDto>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrgDto obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.userId);
    writer.write(obj.profileIcon);
    writer.write(obj.description);
    writer.write(obj.proximity);
    writer.write(obj.location);
    writer.write(obj.isVerified);
    writer.write(obj.createdAt);
    writer.write(obj.type);
    writer.write(obj.jobs);
  }
}

class JobViewDtoAdapter extends TypeAdapter<JobViewDto> {
  @override
  final int typeId = BoxTypes.JOB_INFO;

  @override
  JobViewDto read(BinaryReader reader) {
    return JobViewDto(
      id: reader.readString(),
      title: reader.readString(),
      description: reader.readString(),
      applicant_status: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, JobViewDto obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.write(obj.applicant_status);
  }
}

class LocationsAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 7;

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
      other is LocationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
