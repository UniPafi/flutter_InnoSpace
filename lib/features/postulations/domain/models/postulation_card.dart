class PostulationCard {
  final int collaborationId;
  final int projectId;
  final String projectTitle;
  final String projectDescription;
  final int managerId;
  final String managerName;
  final String companyName;
  final String managerPhotoUrl;
  final String studentResponse;

  PostulationCard({
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
}
