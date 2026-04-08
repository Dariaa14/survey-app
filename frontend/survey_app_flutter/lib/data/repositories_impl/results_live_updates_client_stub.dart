import 'package:survey_app_flutter/data/repositories_impl/results_live_updates_client.dart';

class _NoopResultsLiveUpdatesClient implements ResultsLiveUpdatesClient {
  @override
  Stream<void> get updates => const Stream<void>.empty();

  @override
  void connect() {}

  @override
  void dispose() {}
}

ResultsLiveUpdatesClient createResultsLiveUpdatesClient({
  required String baseUrl,
  required String surveyId,
}) {
  return _NoopResultsLiveUpdatesClient();
}
