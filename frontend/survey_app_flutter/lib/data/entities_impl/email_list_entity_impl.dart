import 'package:survey_app_flutter/data/entities_impl/email_contact_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/email_contact_entity.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';

/// Concrete implementation of [EmailListEntity] used in data layer.
class EmailListEntityImpl implements EmailListEntity {
  /// Creates an [EmailListEntityImpl].
  const EmailListEntityImpl({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.createdAt,
    required this.contacts,
  });

  /// Builds an instance from backend JSON payload.
  factory EmailListEntityImpl.fromJson(Map<String, dynamic> json) {
    return EmailListEntityImpl(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map(
                (e) =>
                    EmailContactEntityImpl.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
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

  @override
  final List<EmailContactEntity> contacts;

  /// Serializes this entity to backend-compatible JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'contacts': contacts
          .map((e) => (e as EmailContactEntityImpl).toJson())
          .toList(),
    };
  }
}
