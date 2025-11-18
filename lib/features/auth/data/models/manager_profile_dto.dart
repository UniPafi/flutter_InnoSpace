class ManagerProfileDto {
  final int id; 
  final int userId;
  final String name;
final String? photoUrl;
  final String? description;
  final String? phoneNumber;
  final String? companyName;
  final String? focusArea;
  final String? location;
  final List<String> companyTechnologies;

  const ManagerProfileDto({
    required this.id,
    required this.userId,
    required this.name,
   this.photoUrl,
    this.description,
    this.phoneNumber,
    this.companyName,
    this.focusArea,
    this.location,
    this.companyTechnologies = const [],
  });

  factory ManagerProfileDto.fromJson(Map<String, dynamic> json) {
    return ManagerProfileDto(
      id: json['id'] as int,
      userId: json['userId'] as int,
      name: json['name'] as String,
       photoUrl: json['photoUrl'],
      description: json['description'],
      phoneNumber: json['phoneNumber'],
      companyName: json['companyName'],
      focusArea: json['focusArea'],
      location: json['location'],
      companyTechnologies: (json['companyTechnologies'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
  
  
}