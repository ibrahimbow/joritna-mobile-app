import 'package:flutter/material.dart';

import '../widgets/joritna_bottom_navigation_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final Color backgroundColor;

  const AppShell({
    super.key,
    required this.child,
    required this.selectedIndex,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: child,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: JoritnaBottomNavigationBar(selectedIndex: selectedIndex),
        ),
      ),
    );
  }
}
