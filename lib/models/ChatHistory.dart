class ChatHistory {
  final int? id;
  final int userId;
  final String message;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatHistory({
    this.id,
    required this.userId,
    required this.message,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
