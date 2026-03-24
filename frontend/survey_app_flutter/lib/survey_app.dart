import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/authentication/authentication_page.dart';
import 'package:survey_app_flutter/utils/theme.dart';

void main() {
  runApp(const SurveyApp());
}

/// The main application widget.
class SurveyApp extends StatelessWidget {
  /// Constructs a [SurveyApp].
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey App',
      theme: darkThemeData,
      home: const AuthenticationPage(),
    );
  }
}
