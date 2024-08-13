class Claim {
  String id;
  String userId;
  String lostItemId;
  String proofText;
  List<String> proofImages;
  String status;
  DateTime createdAt;

  Claim({
    required this.id,
    required this.userId,
    required this.lostItemId,
    required this.proofText,
    required this.proofImages,
    required this.status,
    required this.createdAt,
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      lostItemId: json['lostItemId'] ?? '',
      proofText: json['proofText'] ?? '',
      proofImages: List<String>.from(json['proofImages'] ?? []),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isEmpty ? null : id,
      'userId': userId,
      'lostItemId': lostItemId,
      'proofText': proofText,
      'proofImages': proofImages,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
