// class Message {
//   Message({
//     required this.id,
//     required this.roomId,
//     required this.profileId,
//     required this.content,
//     required this.createdAt,
//     required this.isMine,
//     this.contentLink,
//   });

//   /// ID of the message
//   final String id;

//   /// ID of the user who posted the message
//   final String profileId;

//   /// ID of the room the message belongs to
//   final String roomId;

//   /// Text content of the message
//   final String content;

//   /// Date and time when the message was created
//   final DateTime createdAt;

//   /// Whether the message is sent by the user or not.
//   final bool isMine;

//   ///voice content of the message
//   final String? contentLink;

//   Map<String, dynamic> toMap() {
//     return {
//       'profile_id': profileId,
//       'room_id': roomId,
//       'content': content,
//       'content_link': contentLink,
//     };
//   }

//   Message.fromMap({
//     required Map<String, dynamic> map,
//     required String myUserId,
//   })  : id = map['id'],
//         roomId = map['room_id'],
//         profileId = map['profile_id'],
//         content = map['content'],
//         contentLink = map['content_link'],
//         createdAt = DateTime.parse(map['created_at']),
//         isMine = myUserId == map['profile_id'];

//   Message copyWith({
//     String? id,
//     String? userId,
//     String? roomId,
//     String? text,
//     DateTime? createdAt,
//     String? contentLink,
//     bool? isMine,
//   }) {
//     return Message(
//       id: id ?? this.id,
//       profileId: userId ?? profileId,
//       roomId: roomId ?? this.roomId,
//       content: text ?? content,
//       contentLink: contentLink ?? contentLink!,
//       createdAt: createdAt ?? this.createdAt,
//       isMine: isMine ?? this.isMine,
//     );
//   }
// }

class Message {
  Message({
    required this.id,
    required this.roomId,
    required this.profileId,
    required this.content,
    required this.createdAt,
    required this.isMine,
    this.contentLink,
    required this.isRead,
    required this.isVisible,
    this.reactions,
    this.readTime,
    this.isPlayed,
  });

  /// ID of the message
  final String id;

  /// ID of the user who posted the message
  final String profileId;

  /// ID of the room the message belongs to
  final String roomId;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final DateTime createdAt;

  /// Whether the message is sent by the user or not.
  final bool isMine;

  /// Voice content of the message
  final String? contentLink;

  /// Whether the message has been read
  final bool? isRead;

  /// Whether the message is visible
  final bool? isVisible;

  /// Reactions to the message as jsonb
  final dynamic reactions;

  final DateTime? readTime;

  final bool? isPlayed;

  Map<String, dynamic> toMap() {
    return {
      'profile_id': profileId,
      'room_id': roomId,
      'content': content,
      'content_link': contentLink,
      'isRead': isRead,
      'isVisible': isVisible,
      'reactions': reactions,
      'read_time': readTime?.toIso8601String(),
      'isPlayed': isPlayed,
    };
  }

  Message.fromMap({
    required Map<String, dynamic> map,
    required String myUserId,
  })  : id = map['id'],
        roomId = map['room_id'],
        profileId = map['profile_id'],
        content = map['content'],
        contentLink = map['content_link'],
        createdAt = DateTime.parse(map['created_at']),
        isMine = myUserId == map['profile_id'],
        isRead = map['isRead'],
        isVisible = map['isVisible'],
        reactions = map['reactions'],
        readTime = map['read_time'] != null ? DateTime.parse(map['read_time']) : null,
        isPlayed = map['isPlayed'];

  Message copyWith({
    String? id,
    String? userId,
    String? roomId,
    String? text,
    DateTime? createdAt,
    String? contentLink,
    bool? isMine,
    bool? isRead,
    bool? isVisible,
    dynamic reactions,
    DateTime? readTime,
    bool? isPlayed,
  }) {
    return Message(
      id: id ?? this.id,
      profileId: userId ?? profileId,
      roomId: roomId ?? this.roomId,
      content: text ?? content,
      contentLink: contentLink ?? contentLink!,
      createdAt: createdAt ?? this.createdAt,
      isMine: isMine ?? this.isMine,
      isRead: isRead ?? this.isRead,
      isVisible: isVisible ?? this.isVisible,
      reactions: reactions ?? this.reactions,
      readTime: readTime ?? this.readTime,
      isPlayed: isPlayed ?? this.isPlayed,
    );
  }
}
