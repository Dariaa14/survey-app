import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';

/// Concrete implementation of [EmailListEntity] used in data layer.
class EmailListEntityImpl implements EmailListEntity {
  /// Creates an [EmailListEntityImpl].
  const EmailListEntityImpl({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.createdAt,
  });

  /// Builds an instance from backend JSON payload.
  factory EmailListEntityImpl.fromJson(Map<String, dynamic> json) {
    return EmailListEntityImpl(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  final String id;

  @override
  final String ownerId;

  @override
  final String name;

  @override
  final DateTime createdAt;

  /// Serializes this entity to backend-compatible JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
