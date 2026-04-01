/// Summary data for a CSV import operation.
abstract class EmailListCsvImportSummaryEntity {
  /// Total number of CSV rows processed.
  int get total;

  /// Number of rows considered valid.
  int get valid;

  /// Number of rows considered invalid.
  int get invalid;

  /// Number of rows considered duplicates.
  int get duplicates;
}

/// Valid contact parsed from CSV.
abstract class EmailListCsvValidContactEntity {
  /// Parsed email address.
  String get email;

  /// Parsed contact name.
  String? get name;
}

/// Invalid contact parsed from CSV.
abstract class EmailListCsvInvalidContactEntity {
  /// CSV row number where issue occurred.
  int get row;

  /// Email value from CSV row, when available.
  String? get email;

  /// Validation error details.
  String get error;
}

/// Duplicate contact parsed from CSV.
abstract class EmailListCsvDuplicateContactEntity {
  /// CSV row number where duplicate occurred.
  int get row;

  /// Duplicate email value.
  String get email;
}

/// Result of CSV import endpoint processing.
abstract class EmailListCsvImportResultEntity {
  /// Summary counters.
  EmailListCsvImportSummaryEntity get summary;

  /// Valid contacts parsed from CSV.
  List<EmailListCsvValidContactEntity> get valid;

  /// Invalid contacts parsed from CSV.
  List<EmailListCsvInvalidContactEntity> get invalid;

  /// Duplicate contacts parsed from CSV.
  List<EmailListCsvDuplicateContactEntity> get duplicates;
}
