import 'package:flutter/material.dart';

ThemeData get appTheme {
  return ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    fontFamily: 'monospace',
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF0A0A0A),
      primary: Color(0xFFE0E0E0),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 13,
        height: 1.5,
      ),
      labelSmall: TextStyle(
        color: Color(0xFF888888),
        fontSize: 11,
        letterSpacing: 0.8,
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(const Color(0xFF2A2A2A)),
    ),
    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border.fromBorderSide(BorderSide(color: Color(0xFF2C2C2C))),
      ),
      textStyle: TextStyle(color: Color(0xFF888888), fontSize: 11),
    ),
  );
}
