//need to use notification becoz Notification is a reserved keyword in flutter
class NotificationModel {
  String id;
  String userId;
  String type;
  String message;
  bool read;
  DateTime createdAt;
  DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      read: json['read'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isEmpty ? null : id,
      'userId': userId,
      'type': type,
      'message': message,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
