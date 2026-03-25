import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:survey_app_flutter/utils/app_routes.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';
import 'package:survey_app_flutter/utils/theme.dart';

void main() {
  usePathUrlStrategy();
  runApp(const SurveyApp());
}

/// The main application widget.
class SurveyApp extends StatelessWidget {
  /// Constructs a [SurveyApp].
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appTitle,
      theme: darkThemeData,
      routerConfig: appRouter,
    );
  }
}
