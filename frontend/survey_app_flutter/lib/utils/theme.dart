import 'package:flutter/material.dart';

/// A custom dark color scheme for the Survey App
ColorScheme darkColorScheme = const ColorScheme.dark(
  primary: Color.fromARGB(255, 232, 197, 71),
  primaryContainer: Color.fromARGB(255, 44, 40, 30),
  onPrimary: Color.fromARGB(255, 0, 0, 25),

  secondary: Color.fromARGB(255, 94, 240, 180),
  secondaryContainer: Color.fromARGB(255, 30, 48, 45),

  tertiary: Color.fromARGB(255, 119, 184, 213),
  tertiaryContainer: Color.fromARGB(255, 44, 50, 60),

  surfaceContainer: Color.fromARGB(255, 30, 30, 36),
  surface: Color.fromARGB(255, 17, 17, 21),
  surfaceContainerLow: Color.fromARGB(255, 22, 22, 26),

  onSurfaceVariant: Color.fromARGB(255, 154, 150, 140),
  onSurface: Color.fromARGB(255, 250, 250, 250),

  outline: Color.fromARGB(255, 42, 42, 53),

  error: Color.fromARGB(255, 234, 111, 80),
  errorContainer: Color.fromARGB(255, 48, 33, 33),
  onError: Color.fromARGB(255, 255, 255, 255),
);

/// A custom dark theme for the Survey App
ThemeData darkThemeData = ThemeData(
  colorScheme: darkColorScheme,
  useMaterial3: true,
);
