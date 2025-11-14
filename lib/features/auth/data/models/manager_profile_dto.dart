class ManagerProfileDto {
  final int id; 
  final int userId;
  final String name;
 
  const ManagerProfileDto({
    required this.id,
    required this.userId,
    required this.name,
   
  });

  // Fábrica manual
  factory ManagerProfileDto.fromJson(Map<String, dynamic> json) {
    return ManagerProfileDto(
      id: json['id'] as int,
      userId: json['userId'] as int,
      name: json['name'] as String,
  
    );
  }
  

}