import 'package:app/api/api.dart';
import 'package:app/component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _api = Api();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme(context: context, brightness: Brightness.light).theme(),
      routerConfig: AppRouter(_api).router,
      debugShowCheckedModeBanner: false,
    );
  }
}
