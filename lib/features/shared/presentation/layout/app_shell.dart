import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/user/current_user_provider.dart';
import '../widgets/joritna_bottom_navigation_bar.dart';

class AppShell extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: child,
      bottomNavigationBar: currentUserState.when(
        loading: () => const SizedBox(height: 72),
        error: (_, __) => const SizedBox(height: 72),
        data: (user) {
          return SafeArea(
            top: false,
            child: JoritnaBottomNavigationBar(
              selectedIndex: selectedIndex,
              role: user.role,
            ),
          );
        },
      ),
    );
  }
}
