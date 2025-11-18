enum Status { initial, loading, success, error }


enum OpportunityStatus {
  DRAFT,
  PUBLISHED,
  CLOSED;

  
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