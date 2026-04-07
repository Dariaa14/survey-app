/// Entity representing survey results summary statistics.
///
/// Contains aggregate counts for the invitation and response workflow:
/// - Total invited: Number of people invited to the survey
/// - Total sent: Number of invitation emails actually sent
/// - Email opened: Number of people who opened the invitation email
/// - Survey opened: Number of people who opened the survey after email
/// - Submitted: Number of people who completed and submitted the survey
abstract class ResultsSummaryEntity {
  /// Total number of people invited to this survey.
  int get invited;

  /// Total number of invitation emails that were sent.
  int get sent;

  /// Total number of people who opened the invitation email.
  int get emailOpened;

  /// Total number of people who opened the survey page.
  int get surveyOpened;

  /// Total number of people who submitted a response.
  int get submitted;

  /// Total number of bounced invitation emails.
  int get bounced;
}
