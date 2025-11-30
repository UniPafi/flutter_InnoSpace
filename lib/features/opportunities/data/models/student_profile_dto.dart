class StudentProfileDto {
  final int id;
  final String description;
  final String phoneNumber;
  final List<String> skills;

  StudentProfileDto({
    required this.id,
    required this.description,
    required this.phoneNumber,
    required this.skills,
  });

  factory StudentProfileDto.fromJson(Map<String, dynamic> json) {
    return StudentProfileDto(
      id: json['id'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}