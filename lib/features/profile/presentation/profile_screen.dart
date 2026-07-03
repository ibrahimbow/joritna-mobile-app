import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/presentation/layout/app_shell.dart';
import '../../tenant/building/data/building_providers.dart';
import '../data/profile_providers.dart';
import 'widgets/profile_app_bar.dart';
import 'widgets/profile_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final buildingState = ref.watch(myBuildingProvider);

    final content = SafeArea(
      child: Column(
        children: [
          const ProfileAppBar(),
          Expanded(
            child: profileState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Could not load profile')),
              data: (profile) => ProfileCard(profile: profile),
            ),
          ),
        ],
      ),
    );

    return buildingState.when(
      loading: () => const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      ),
      error: (_, __) => Scaffold(body: content),
      data: (_) => AppShell(selectedIndex: 3, child: content),
    );
  }
}
