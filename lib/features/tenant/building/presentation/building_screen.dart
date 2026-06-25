import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/layout/app_shell.dart';
import '../data/building_providers.dart';
import '../data/models/building.dart';
import '../data/models/requests/join_building_request.dart';

class BuildingScreen extends ConsumerWidget {
  const BuildingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingState = ref.watch(myBuildingProvider);

    return buildingState.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const _JoinBuildingView(),
      data: (building) {
        return AppShell(
          selectedIndex: 1,
          child: SafeArea(child: _BuildingDetailsView(building: building)),
        );
      },
    );
  }
}

class _JoinBuildingView extends ConsumerStatefulWidget {
  const _JoinBuildingView();

  @override
  ConsumerState<_JoinBuildingView> createState() => _JoinBuildingViewState();
}

class _JoinBuildingViewState extends ConsumerState<_JoinBuildingView> {
  final _codeController = TextEditingController();

  bool _isJoining = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinBuilding() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Building code is required';
      });
      return;
    }

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(buildingRepositoryProvider)
          .joinBuilding(JoinBuildingRequest(code: code));

      ref.invalidate(myBuildingProvider);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Could not join building. Please check the code.';
      });
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.apartment_rounded,
                    size: 72,
                    color: Color(0xFF0057C8),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Join your building',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter the building code from your manager to access announcements, chat, and Share & Help.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Building code',
                      hintText: 'Example: BM-447124',
                      prefixIcon: const Icon(Icons.key_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _isJoining ? null : _joinBuilding,
                      icon: _isJoining
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login_rounded),
                      label: Text(_isJoining ? 'Joining...' : 'Join Building'),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'You only need to join your building once.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildingDetailsView extends ConsumerWidget {
  final Building building;

  const _BuildingDetailsView({required this.building});

  Future<void> _leaveBuilding(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave building'),
          content: const Text('Are you sure you want to leave this building?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(buildingRepositoryProvider).leaveBuilding();

    ref.invalidate(myBuildingProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Building Details',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your private building community information.',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        const SizedBox(height: 24),
        _InfoTile(
          icon: Icons.apartment_rounded,
          title: 'Building',
          value: building.buildingName,
        ),
        _InfoTile(
          icon: Icons.location_on_outlined,
          title: 'Address',
          value: building.address,
        ),
        _InfoTile(
          icon: Icons.person_outline_rounded,
          title: 'Manager',
          value: building.managerName,
        ),
        _InfoTile(
          icon: Icons.key_rounded,
          title: 'Building code',
          value: building.code,
        ),
        _InfoTile(
          icon: Icons.home_work_outlined,
          title: 'Apartments',
          value: '${building.totalApartments}',
        ),
        _InfoTile(
          icon: Icons.phone_rounded,
          title: 'Emergency phone',
          value: building.emergencyPhone,
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => _leaveBuilding(context, ref),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Leave Building'),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0057C8)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
