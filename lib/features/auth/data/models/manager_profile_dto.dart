class ManagerProfileDto {
  final int id; // managerId
  final int userId;
  final String name;
  // Añade más campos si los necesitas
  // final String? photoUrl;
  // final String? description;

  const ManagerProfileDto({
    required this.id,
    required this.userId,
    required this.name,
    // this.photoUrl,
    // this.description,
  });

  // Fábrica manual
  factory ManagerProfileDto.fromJson(Map<String, dynamic> json) {
    return ManagerProfileDto(
      id: json['id'] as int,
      userId: json['userId'] as int,
      name: json['name'] as String,
      // photoUrl: json['photoUrl'],
      // description: json['description'],
    );
  }
  
  // Este DTO no necesita un .toDomain() porque solo
  // lo usamos para extraer el 'id' y el 'userId'.
}