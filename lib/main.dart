import 'package:flutter/material.dart';
import 'package:kpi_test/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(const ProviderScope(child: App()));
}
