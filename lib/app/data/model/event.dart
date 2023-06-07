class EventModel {
  final String? schema;
  final String? table;
  final DateTime? commitTimestamp;
  final String? eventType;
  final MessageModel? newMessage;
  final Map<String, dynamic>? old;
  final dynamic errors;

  EventModel({
    this.schema,
    this.table,
    this.commitTimestamp,
    this.eventType,
    this.newMessage,
    this.old,
    this.errors,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      schema: json['schema'],
      table: json['table'],
      commitTimestamp: DateTime.parse(json['commit_timestamp']),
      eventType: json['eventType'],
      newMessage: MessageModel.fromJson(json['new']),
      old: json['old'],
      errors: json['errors'],
    );
  }
}

class MessageModel {
  final String content;
  final DateTime createdAt;
  final String id;
  final String profileId;
  final String roomId;

  MessageModel({
    required this.content,
    required this.createdAt,
    required this.id,
    required this.profileId,
    required this.roomId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
      profileId: json['profile_id'],
      roomId: json['room_id'],
    );
  }
}
