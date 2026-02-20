import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EquiTheraHub());
}

class EquiTheraHub extends StatelessWidget {
  const EquiTheraHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EquiThera Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
