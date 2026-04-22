import 'package:flutter/material.dart';
import 'package:kpi_test/constants/theme.dart';
import 'package:kpi_test/screens/board_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BoardScreen(),
      theme: appTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
