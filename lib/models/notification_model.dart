class Notification {
  String id;
  String userId;
  String message;
  bool read;
  DateTime createdAt;
  DateTime updatedAt;

  Notification({
    required this.id,
    required this.userId,
    required this.message,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      message: json['message'] ?? '',
      read: json['read'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isEmpty ? null : id,
      'userId': userId,
      'message': message,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
