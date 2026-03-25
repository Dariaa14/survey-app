import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/my_surveys_list_section.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/widgets/surveys_list_top_bar.dart';

/// A page that displays the list of surveys for the admin.
class SurveysListPage extends StatefulWidget {
  /// Constructs a [SurveysListPage].
  const SurveysListPage({super.key});

  @override
  State<SurveysListPage> createState() => _SurveysListPageState();
}

class _SurveysListPageState extends State<SurveysListPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SurveysListTopBar(
                  onTabSelected: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  selectedTabIndex: _selectedTabIndex,
                ),
                if (_selectedTabIndex == 0) ...[
                  const SizedBox(height: 24),
                  const MySurveysListSection(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
