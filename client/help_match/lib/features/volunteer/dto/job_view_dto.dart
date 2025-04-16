part of './org_dto.dart';
@HiveType(typeId: BoxTypes.JOB_INFO)
class JobViewDto {
@HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;
@HiveField(3)
final String ?applicant_status;

  JobViewDto({required this.id,required this.title, required this.description,required this.applicant_status});

  factory JobViewDto.fromJson(Map<String, dynamic> json) {
    return JobViewDto(
      id:json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      applicant_status: json['applicant_status'],
    );
  }
 
}
