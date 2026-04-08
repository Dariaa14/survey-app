import 'results_live_updates_client_stub.dart'
    if (dart.library.html) 'results_live_updates_client_web.dart'
    as impl;

abstract class ResultsLiveUpdatesClient {
  Stream<void> get updates;

  void connect();

  void dispose();
}

ResultsLiveUpdatesClient createResultsLiveUpdatesClient({
  required String baseUrl,
  required String surveyId,
}) {
  return impl.createResultsLiveUpdatesClient(
    baseUrl: baseUrl,
    surveyId: surveyId,
  );
}
