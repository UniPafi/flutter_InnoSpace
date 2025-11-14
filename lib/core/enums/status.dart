enum Status { initial, loading, success, error }

// ¡NUEVO!
enum OpportunityStatus {
  DRAFT,
  PUBLISHED,
  CLOSED;

  // Helper para convertir el string del API a nuestro enum
  static OpportunityStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PUBLISHED':
        return OpportunityStatus.PUBLISHED;
      case 'CLOSED':
        return OpportunityStatus.CLOSED;
      case 'DRAFT':
      default:
        return OpportunityStatus.DRAFT;
    }
  }
}