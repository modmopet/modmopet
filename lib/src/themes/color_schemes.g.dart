import 'package:flutter/material.dart';

class MMColors {
  MMColors._();
  static final instance = MMColors._();

  Color get primary => const Color.fromARGB(255, 193, 12, 51);
  Color get secondary => const Color.fromARGB(255, 137, 219, 201);
  Color get lightWhite => Colors.white.withAlpha(230);
  Color get background => const Color.fromARGB(255, 32, 42, 40);
  Color get bodyText => const Color.fromARGB(255, 247, 244, 244);
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6F4DA0),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFEDDCFF),
  onPrimaryContainer: Color(0xFF280056),
  secondary: Color(0xFF704D9F),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFEDDCFF),
  onSecondaryContainer: Color(0xFF290055),
  tertiary: Color(0xFF7F525B),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD9DF),
  onTertiaryContainer: Color(0xFF321019),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF1D1B1E),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF1D1B1E),
  surfaceVariant: Color(0xFFE8E0EB),
  onSurfaceVariant: Color(0xFF4A454E),
  outline: Color(0xFF7B757F),
  onInverseSurface: Color(0xFFF5EFF4),
  inverseSurface: Color(0xFF322F33),
  inversePrimary: Color(0xFFD7BAFF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF6F4DA0),
  outlineVariant: Color(0xFFCCC4CF),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 193, 12, 51),
  onPrimary: Color(0xFF3F1B6E),
  primaryContainer: Color(0xFF563586),
  onPrimaryContainer: Color(0xFFEDDCFF),
  secondary: Color.fromARGB(255, 202, 162, 171),
  onSecondary: Color(0xFF401B6E),
  secondaryContainer: Color(0xFF573486),
  onSecondaryContainer: Color(0xFFEDDCFF),
  tertiary: Color(0xFFF2B7C2),
  onTertiary: Color(0xFF4B252E),
  tertiaryContainer: Color(0xFF653B44),
  onTertiaryContainer: Color(0xFFFFD9DF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1D1B1E),
  onBackground: Color(0xFFE7E1E6),
  surface: Color(0xFF1D1B1E),
  onSurface: Color(0xFFE7E1E6),
  surfaceVariant: Color(0xFF4A454E),
  onSurfaceVariant: Color(0xFFCCC4CF),
  outline: Color(0xFF958E99),
  onInverseSurface: Color(0xFF1D1B1E),
  inverseSurface: Color(0xFFE7E1E6),
  inversePrimary: Color(0xFF6F4DA0),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFD7BAFF),
  outlineVariant: Color(0xFF4A454E),
  scrim: Color(0xFF000000),
);
