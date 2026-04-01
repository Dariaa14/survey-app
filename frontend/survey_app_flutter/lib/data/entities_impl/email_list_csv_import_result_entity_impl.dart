import 'package:survey_app_flutter/domain/entities/email_list_csv_import_result_entity.dart';

/// Concrete implementation of [EmailListCsvImportSummaryEntity].
class EmailListCsvImportSummaryEntityImpl
    implements EmailListCsvImportSummaryEntity {
  /// Creates an [EmailListCsvImportSummaryEntityImpl].
  const EmailListCsvImportSummaryEntityImpl({
    required this.total,
    required this.valid,
    required this.invalid,
    required this.duplicates,
  });

  /// Builds an instance from backend JSON payload.
  factory EmailListCsvImportSummaryEntityImpl.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmailListCsvImportSummaryEntityImpl(
      total: json['total'] as int? ?? 0,
      valid: json['valid'] as int? ?? 0,
      invalid: json['invalid'] as int? ?? 0,
      duplicates: json['duplicates'] as int? ?? 0,
    );
  }

  @override
  final int total;

  @override
  final int valid;

  @override
  final int invalid;

  @override
  final int duplicates;
}

/// Concrete implementation of [EmailListCsvValidContactEntity].
class EmailListCsvValidContactEntityImpl
    implements EmailListCsvValidContactEntity {
  /// Creates an [EmailListCsvValidContactEntityImpl].
  const EmailListCsvValidContactEntityImpl({
    required this.email,
    this.name,
  });

  /// Builds an instance from backend JSON payload.
  factory EmailListCsvValidContactEntityImpl.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmailListCsvValidContactEntityImpl(
      email: json['email'] as String,
      name: json['name'] as String?,
    );
  }

  @override
  final String email;

  @override
  final String? name;
}

/// Concrete implementation of [EmailListCsvInvalidContactEntity].
class EmailListCsvInvalidContactEntityImpl
    implements EmailListCsvInvalidContactEntity {
  /// Creates an [EmailListCsvInvalidContactEntityImpl].
  const EmailListCsvInvalidContactEntityImpl({
    required this.row,
    required this.error,
    this.email,
  });

  /// Builds an instance from backend JSON payload.
  factory EmailListCsvInvalidContactEntityImpl.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmailListCsvInvalidContactEntityImpl(
      row: json['row'] as int? ?? 0,
      email: json['email'] as String?,
      error: json['error'] as String? ?? 'Unknown error',
    );
  }

  @override
  final int row;

  @override
  final String? email;

  @override
  final String error;
}

/// Concrete implementation of [EmailListCsvDuplicateContactEntity].
class EmailListCsvDuplicateContactEntityImpl
    implements EmailListCsvDuplicateContactEntity {
  /// Creates an [EmailListCsvDuplicateContactEntityImpl].
  const EmailListCsvDuplicateContactEntityImpl({
    required this.row,
    required this.email,
  });

  /// Builds an instance from backend JSON payload.
  factory EmailListCsvDuplicateContactEntityImpl.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmailListCsvDuplicateContactEntityImpl(
      row: json['row'] as int? ?? 0,
      email: json['email'] as String? ?? '',
    );
  }

  @override
  final int row;

  @override
  final String email;
}

/// Concrete implementation of [EmailListCsvImportResultEntity].
class EmailListCsvImportResultEntityImpl
    implements EmailListCsvImportResultEntity {
  /// Creates an [EmailListCsvImportResultEntityImpl].
  const EmailListCsvImportResultEntityImpl({
    required this.summary,
    required this.valid,
    required this.invalid,
    required this.duplicates,
  });

  /// Builds an instance from backend JSON payload.
  factory EmailListCsvImportResultEntityImpl.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmailListCsvImportResultEntityImpl(
      summary: EmailListCsvImportSummaryEntityImpl.fromJson(
        json['summary'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      valid: (json['valid'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (entry) => EmailListCsvValidContactEntityImpl.fromJson(
              entry as Map<String, dynamic>,
            ),
          )
          .toList(),
      invalid: (json['invalid'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (entry) => EmailListCsvInvalidContactEntityImpl.fromJson(
              entry as Map<String, dynamic>,
            ),
          )
          .toList(),
      duplicates: (json['duplicates'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (entry) => EmailListCsvDuplicateContactEntityImpl.fromJson(
              entry as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  @override
  final EmailListCsvImportSummaryEntity summary;

  @override
  final List<EmailListCsvValidContactEntity> valid;

  @override
  final List<EmailListCsvInvalidContactEntity> invalid;

  @override
  final List<EmailListCsvDuplicateContactEntity> duplicates;
}
