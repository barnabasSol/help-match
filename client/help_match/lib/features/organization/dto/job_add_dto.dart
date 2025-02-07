class JobDto {
  final String title;
  final String description;

  JobDto({required this.title, required this.description});

  factory JobDto.fromJson(Map<String, dynamic> json) {
    return JobDto(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
