import 'message.dart';

class Room {
  Room({
    required this.id,
    required this.createdAt,
    required this.otherUserId,
    this.lastMessage,
    this.isVisible,
  });

  /// ID of the room
  final String id;

  /// Date and time when the room was created
  final DateTime createdAt;

  /// ID of the user who the user is talking to
  final String otherUserId;

  /// Latest message submitted in the room
  final Message? lastMessage;

  final bool? isVisible;
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isVisible': isVisible,
    };
  }

  /// Creates a room object from room_participants table
  Room.fromRoomParticipants(Map<String, dynamic> map, bool? isVisible)
      : id = map['room_id'],
        otherUserId = map['profile_id'],
        createdAt = DateTime.parse(map['created_at']),
        isVisible = isVisible,
        lastMessage = null;

  Room copyWith({
    String? id,
    DateTime? createdAt,
    String? otherUserId,
    Message? lastMessage,
    bool? isVisible,
  }) {
    return Room(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      otherUserId: otherUserId ?? this.otherUserId,
      lastMessage: lastMessage ?? this.lastMessage,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
