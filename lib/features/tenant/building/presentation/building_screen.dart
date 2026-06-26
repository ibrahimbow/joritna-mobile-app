import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/file/file_url_resolver.dart';
import '../../../../core/user/current_user_provider.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../data/building_providers.dart';
import '../data/models/building.dart';
import '../data/models/requests/join_building_request.dart';

class BuildingScreen extends ConsumerWidget {
  const BuildingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingState = ref.watch(
      myBuildingProvider,
    );

    return buildingState.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const _JoinBuildingView(),
      data: (building) => AppShell(
        selectedIndex: 1,
        child: SafeArea(
          child: _BuildingDetailsView(
            building: building,
          ),
        ),
      ),
    );
  }
}

class _JoinBuildingView extends ConsumerStatefulWidget {
  const _JoinBuildingView();

  @override
  ConsumerState<_JoinBuildingView> createState() => _JoinBuildingViewState();
}

class _JoinBuildingViewState extends ConsumerState<_JoinBuildingView> {
  final TextEditingController _codeController = TextEditingController();

  bool _isJoining = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinBuilding() async {
    final code = _codeController.text.trim();

    if (code.isEmpty || _isJoining) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your building code.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isJoining = true;
    });

    try {
      await ref.read(buildingRepositoryProvider).joinBuilding(
            JoinBuildingRequest(
              code: code,
            ),
          );

      ref.invalidate(
        myBuildingProvider,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You joined the building successfully.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not join building. Please check the code.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserState = ref.watch(
      currentUserProvider,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: currentUserState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const Center(
            child: Text(
              'Could not load your profile.',
            ),
          ),
          data: (currentUser) {
            return Column(
              children: [
                _WelcomeHeader(
                  displayName: currentUser.displayName,
                  role: currentUser.role,
                  avatarUrl: currentUser.avatarUrl,
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(
                          24,
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.apartment_rounded,
                              size: 64,
                              color: Color(0xFF0057C8),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const Text(
                              'Join your building',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              'Enter the building code from your manager to access announcements, chat, and Share & Help.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            TextField(
                              controller: _codeController,
                              enabled: !_isJoining,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                labelText: 'Building code',
                                hintText: 'Example: BM-447124',
                                prefixIcon: const Icon(
                                  Icons.key_rounded,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton.icon(
                                onPressed: _isJoining ? null : _joinBuilding,
                                icon: _isJoining
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.login_rounded,
                                      ),
                                label: Text(
                                  _isJoining
                                      ? 'Joining...'
                                      : 'Join Building',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            const Text(
                              'You only need to join your building once.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({
    required this.displayName,
    required this.role,
    required this.avatarUrl,
  });

  final String displayName;
  final String role;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final resolvedAvatarUrl = FileUrlResolver.resolve(
      avatarUrl,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        20,
        16,
        32,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F2A5F),
            Color(0xFF0057C8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: Colors.white,
            backgroundImage: resolvedAvatarUrl.isNotEmpty
                ? NetworkImage(
                    resolvedAvatarUrl,
                  )
                : null,
            child: resolvedAvatarUrl.isEmpty
                ? const Icon(
                    Icons.person_rounded,
                    size: 42,
                    color: Color(0xFF0057C8),
                  )
                : null,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: 0.85,
                    ),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.2,
                    ),
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  child: Text(
                    role.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.go(
              AppRoutes.tenantSettings,
            ),
            icon: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildingDetailsView extends StatelessWidget {
  const _BuildingDetailsView({
    required this.building,
  });

  final Building building;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(
        20,
      ),
      children: [
        const Text(
          'My Building',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building.buildingName,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  building.address,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}