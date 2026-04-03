import 'package:survey_app_flutter/data/entities_impl/email_contact_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/email_contact_entity.dart';
import 'package:survey_app_flutter/domain/entities/invitation_entity.dart';

/// Concrete implementation of [InvitationEntity] used in the app.
class InvitationEntityImpl implements InvitationEntity {
  @override
  final String id;

  @override
  final String surveyId;

  @override
  final String contactId;

  @override
  final String tokenHash;

  @override
  final DateTime sentAt;

  @override
  final DateTime? emailOpenedAt;

  @override
  final DateTime? surveyOpenedAt;

  @override
  final DateTime? submittedAt;

  @override
  final DateTime? bouncedAt;

  @override
  final EmailContactEntity contact;

  /// Constructs an [InvitationEntityImpl] with the given properties.
  InvitationEntityImpl({
    required this.id,
    required this.surveyId,
    required this.contactId,
    required this.tokenHash,
    required this.sentAt,
    required this.contact,
    this.emailOpenedAt,
    this.surveyOpenedAt,
    this.submittedAt,
    this.bouncedAt,
  });

  /// Factory constructor to create an [InvitationEntityImpl] from a JSON map.
  factory InvitationEntityImpl.fromJson(Map<String, dynamic> json) {
    return InvitationEntityImpl(
      id: json['id'] as String,
      surveyId: json['survey_id'] as String,
      contactId: json['contact_id'] as String,
      tokenHash: json['token_hash'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
      emailOpenedAt: json['email_opened_at'] != null
          ? DateTime.parse(
              json['email_opened_at'] as String,
            )
          : null,
      surveyOpenedAt: json['survey_opened_at'] != null
          ? DateTime.parse(
              json['survey_opened_at'] as String,
            )
          : null,
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(
              json['submitted_at'] as String,
            )
          : null,
      bouncedAt: json['bounced_at'] != null
          ? DateTime.parse(json['bounced_at'] as String)
          : null,
      contact: EmailContactEntityImpl.fromJson(
        json['contact'] as Map<String, dynamic>,
      ),
    );
  }

  /// Converts this [InvitationEntityImpl] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'survey_id': surveyId,
      'contact_id': contactId,
      'token_hash': tokenHash,
      'sent_at': sentAt.toIso8601String(),
      'email_opened_at': emailOpenedAt?.toIso8601String(),
      'survey_opened_at': surveyOpenedAt?.toIso8601String(),
      'submitted_at': submittedAt?.toIso8601String(),
      'bounced_at': bouncedAt?.toIso8601String(),
      'contact': (contact as EmailContactEntityImpl).toJson(),
    };
  }
}
