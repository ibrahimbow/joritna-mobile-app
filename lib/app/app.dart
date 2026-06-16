import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'config/app_config.dart';

class JoritnaMobileApp extends StatelessWidget {
  const JoritnaMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
     title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}