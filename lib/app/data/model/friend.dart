class Friend {
  final int id;
  final DateTime createdAt;
  final String profileId;
  final String friendId;
  final String isAccepted;

  Friend({
    required this.id,
    required this.createdAt,
    required this.profileId,
    required this.friendId,
    required this.isAccepted,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      profileId: json['profile_id'] as String,
      friendId: json['friend_id'] as String,
      isAccepted: json['isAccepted'] as String,
    );
  }
}
