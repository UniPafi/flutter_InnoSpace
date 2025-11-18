import 'package:equatable/equatable.dart';

class ManagerProfile extends Equatable {
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

  const ManagerProfile({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        photoUrl,
        description,
        phoneNumber,
        companyName,
        focusArea,
        location,
        companyTechnologies,
      ];
}