import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_state.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list/survey_list_page.dart';
import 'package:survey_app_flutter/presentation/admin/widgets/admin_top_bar.dart';
import 'package:survey_app_flutter/presentation/bloc_listeners/bloc_providers.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';

/// A page that displays the admin main interface, including the surveys list
/// and other admin sections.
class AdminMainPage extends StatefulWidget {
  /// Constructs a [AdminMainPage].
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    AppBlocs.adminBloc.add(const AdminAccountRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviders(
      child: BlocListener<AdminBloc, AdminState>(
        listener: (context, state) {
          AppBlocs.adminBloc.add(const AdminSurveysRequested());
        },
        listenWhen: (previous, current) =>
            previous.adminUser != current.adminUser,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminTopBar(
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      selectedTabIndex: _selectedTabIndex,
                    ),
                    if (_selectedTabIndex == 0) ...[
                      const SizedBox(height: 24),
                      const SurveyListPage(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
