import 'package:app/api/api.dart';
import 'package:app/component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _api = Api();

  @override
  Widget build(BuildContext context) {
    print('build called on main app');
    print(_api.isUserSignedIn);
    return MaterialApp.router(
      theme: AppTheme(context: context, brightness: Brightness.light).theme(),
      routerConfig: AppRouter(_api).router,
      debugShowCheckedModeBanner: false,
    );
  }
}
