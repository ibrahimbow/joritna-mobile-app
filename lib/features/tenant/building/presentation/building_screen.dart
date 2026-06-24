import 'package:flutter/material.dart';
import '../../../shared/presentation/layout/app_shell.dart';

class BuildingScreen extends StatelessWidget {
  const BuildingScreen({super.key});

 @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 1,
      child: SafeArea(
        child: Text('Building'),
      ),
    );
  }
}