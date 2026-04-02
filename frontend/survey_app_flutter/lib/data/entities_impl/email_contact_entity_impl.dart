import 'package:survey_app_flutter/domain/entities/email_contact_entity.dart';

/// Concrete implementation of [EmailContactEntity] used in data layer.
class EmailContactEntityImpl implements EmailContactEntity {
  @override
  final String email;

  @override
  final String name;

  @override
  final String id;

  @override
  final String listId;

  @override
  final DateTime createdAt;

  /// Creates an [EmailContactEntityImpl].
  EmailContactEntityImpl({
    required this.id,
    required this.listId,
    required this.createdAt,
    required this.email,
    required this.name,
  });

  /// Builds an instance from backend JSON payload.
  factory EmailContactEntityImpl.fromJson(Map<String, dynamic> json) {
    return EmailContactEntityImpl(
      id: json['id'] as String,
      listId: json['list_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Serializes this entity to backend-compatible JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'list_id': listId,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
