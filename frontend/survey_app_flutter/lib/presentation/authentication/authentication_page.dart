import 'package:flutter/material.dart';

/// A page that displays the authentication screen.
class AuthenticationPage extends StatelessWidget {
  /// Constructs an [AuthenticationPage].
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome to the Survey App!"),
          Text("Please sign in to continue."),
        ],
      ),
    );
  }
}
