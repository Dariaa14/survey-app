import 'package:survey_app_flutter/domain/entities/invitation_preview_entity.dart';

/// Concrete implementation of [InvitationPreviewEntity] used in the app.
class InvitationPreviewEntityImpl implements InvitationPreviewEntity {
  /// Constructs an [InvitationPreviewEntityImpl].
  const InvitationPreviewEntityImpl({
    required this.newInvitations,
    required this.skipped,
  });

  /// Factory constructor to create an [InvitationPreviewEntityImpl] from JSON.
  factory InvitationPreviewEntityImpl.fromJson(Map<String, dynamic> json) {
    return InvitationPreviewEntityImpl(
      newInvitations: (json['new'] as num).toInt(),
      skipped: (json['skipped'] as num).toInt(),
    );
  }

  @override
  final int newInvitations;

  @override
  final int skipped;

  /// Converts this entity to JSON.
  Map<String, dynamic> toJson() {
    return {
      'new': newInvitations,
      'skipped': skipped,
    };
  }
}
