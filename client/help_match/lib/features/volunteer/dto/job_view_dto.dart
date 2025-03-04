class JobViewDto {
  final String id;
  final String title;
  final String description;

  JobViewDto({required this.id,required this.title, required this.description});

  factory JobViewDto.fromJson(Map<String, dynamic> json) {
    return JobViewDto(
      id:json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
 
}
