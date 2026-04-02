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

  /// Constructs an [InvitationEntityImpl] with the given properties.
  InvitationEntityImpl({
    required this.id,
    required this.surveyId,
    required this.contactId,
    required this.tokenHash,
    required this.sentAt,
    this.emailOpenedAt,
    this.surveyOpenedAt,
    this.submittedAt,
    this.bouncedAt,
  });

  /// Factory constructor to create an [InvitationEntityImpl] from a JSON map.
  factory InvitationEntityImpl.fromJson(Map<String, dynamic> json) {
    final sentAtValue = json['sentAt'] ?? json['sent_at'] ?? json['created_at'];

    return InvitationEntityImpl(
      id: json['id'] as String,
      surveyId: (json['surveyId'] ?? json['survey_id']) as String,
      contactId: (json['contactId'] ?? json['contact_id']) as String,
      tokenHash: (json['tokenHash'] ?? json['token_hash']) as String,
      sentAt: DateTime.parse(sentAtValue as String),
      emailOpenedAt: (json['emailOpenedAt'] ?? json['email_opened_at']) != null
          ? DateTime.parse(
              (json['emailOpenedAt'] ?? json['email_opened_at']) as String,
            )
          : null,
      surveyOpenedAt:
          (json['surveyOpenedAt'] ?? json['survey_opened_at']) != null
          ? DateTime.parse(
              (json['surveyOpenedAt'] ?? json['survey_opened_at']) as String,
            )
          : null,
      submittedAt: (json['submittedAt'] ?? json['submitted_at']) != null
          ? DateTime.parse(
              (json['submittedAt'] ?? json['submitted_at']) as String,
            )
          : null,
      bouncedAt: (json['bouncedAt'] ?? json['bounced_at']) != null
          ? DateTime.parse((json['bouncedAt'] ?? json['bounced_at']) as String)
          : null,
    );
  }

  /// Converts this [InvitationEntityImpl] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surveyId': surveyId,
      'contactId': contactId,
      'tokenHash': tokenHash,
      'sentAt': sentAt.toIso8601String(),
      'emailOpenedAt': emailOpenedAt?.toIso8601String(),
      'surveyOpenedAt': surveyOpenedAt?.toIso8601String(),
      'submittedAt': submittedAt?.toIso8601String(),
      'bouncedAt': bouncedAt?.toIso8601String(),
    };
  }
}
