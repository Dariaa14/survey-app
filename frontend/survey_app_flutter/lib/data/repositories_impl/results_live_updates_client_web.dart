import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:survey_app_flutter/data/repositories_impl/results_live_updates_client.dart';

class _WebResultsLiveUpdatesClient implements ResultsLiveUpdatesClient {
  _WebResultsLiveUpdatesClient({
    required String baseUrl,
    required String surveyId,
  }) : _url = '$baseUrl/surveys/$surveyId/results/stream';

  final String _url;
  final StreamController<void> _controller = StreamController<void>.broadcast();
  html.EventSource? _eventSource;

  @override
  Stream<void> get updates => _controller.stream;

  @override
  void connect() {
    _eventSource?.close();
    _eventSource = html.EventSource(_url);

    _eventSource?.onMessage.listen((event) {
      try {
        final rawData = event.data;
        if (rawData == null) {
          return;
        }

        final payload = jsonDecode(rawData.toString()) as Map<String, dynamic>;
        if (payload['type'] == 'response_created') {
          _controller.add(null);
        }
      } catch (_) {
        // Ignore malformed SSE payloads.
      }
    });
  }

  @override
  void dispose() {
    _eventSource?.close();
    _eventSource = null;
    _controller.close();
  }
}

ResultsLiveUpdatesClient createResultsLiveUpdatesClient({
  required String baseUrl,
  required String surveyId,
}) {
  return _WebResultsLiveUpdatesClient(baseUrl: baseUrl, surveyId: surveyId);
}
