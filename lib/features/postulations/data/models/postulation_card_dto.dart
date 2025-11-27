class PostulationCardDto {
  final int collaborationId;
  final int projectId;
  final String projectTitle;
  final String projectDescription;
  final int managerId;
  final String managerName;
  final String companyName;
  final String managerPhotoUrl;
  final String studentResponse;

  PostulationCardDto({
    required this.collaborationId,
    required this.projectId,
    required this.projectTitle,
    required this.projectDescription,
    required this.managerId,
    required this.managerName,
    required this.companyName,
    required this.managerPhotoUrl,
    required this.studentResponse,
  });

  factory PostulationCardDto.fromJson(Map<String, dynamic> json) {
    return PostulationCardDto(
      collaborationId: json["collaborationId"],
      projectId: json["projectId"],
      projectTitle: json["projectTitle"],
      projectDescription: json["projectDescription"],
      managerId: json["managerId"],
      managerName: json["managerName"],
      companyName: json["companyName"],
      managerPhotoUrl: json["managerPhotoUrl"],
      studentResponse: json["studentResponse"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "collaborationId": collaborationId,
      "projectId": projectId,
      "projectTitle": projectTitle,
      "projectDescription": projectDescription,
      "managerId": managerId,
      "managerName": managerName,
      "companyName": companyName,
      "managerPhotoUrl": managerPhotoUrl,
      "studentResponse": studentResponse,
    };
  }
}