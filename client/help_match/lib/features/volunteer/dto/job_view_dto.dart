class JobViewDto {
  final String id;
  final String title;
  final String description;
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
