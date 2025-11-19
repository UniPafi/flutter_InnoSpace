class FavoriteProjectEntity {
  final int id;

  const FavoriteProjectEntity({required this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory FavoriteProjectEntity.fromMap(Map<String, dynamic> map) {
    return FavoriteProjectEntity(
      id: map['id'] as int,
    );
  }
}