class ActivityLog {
  final int? id;
  final int adminId;
  final String action;
  final String? modelType;
  final int? modelId;
  final String? description;
  final DateTime? createdAt;

  ActivityLog({
    this.id,
    required this.adminId,
    required this.action,
    this.modelType,
    this.modelId,
    this.description,
    this.createdAt,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'],
      adminId: json['admin_id'],
      action: json['action'],
      modelType: json['model_type'],
      modelId: json['model_id'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'action': action,
      'model_type': modelType,
      'model_id': modelId,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
