import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/layout/app_shell.dart';
import '../data/building_providers.dart';
import '../data/models/requests/join_building_request.dart';
import 'widgets/building_action_card.dart';
import 'widgets/building_header_card.dart';
import 'widgets/building_information_card.dart';
import 'widgets/building_manager_card.dart';
import 'widgets/manager_contact_card.dart';

class BuildingScreen extends ConsumerWidget {
  const BuildingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingState = ref.watch(myBuildingProvider);

    return buildingState.when(
      loading: () => const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      ),
      error: (_, __) => const _JoinBuildingView(),
      data: (building) => AppShell(
        selectedIndex: 1,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myBuildingProvider);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                const Text(
                  'Building',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your residential community details.',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                BuildingHeaderCard(building: building),
                const SizedBox(height: 16),

                BuildingManagerCard(building: building),
                const SizedBox(height: 16),

                BuildingInformationCard(building: building),
                const SizedBox(height: 16),

                ManagerContactCard(building: building),
                const SizedBox(height: 16),

                BuildingActionCard(
                  onLeaveBuilding: () => _confirmLeaveBuilding(context, ref),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLeaveBuilding(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Leave building?'),
          content: const Text(
            'You will lose access to announcements, chat, and Share & Help until you join a building again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
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
}

class _JoinBuildingView extends ConsumerStatefulWidget {
  const _JoinBuildingView();

  @override
  ConsumerState<_JoinBuildingView> createState() => _JoinBuildingViewState();
}

class _JoinBuildingViewState extends ConsumerState<_JoinBuildingView> {
  final TextEditingController _codeController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.apartment_rounded,
                size: 38,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Join your building',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the building code provided by your building manager to access your community.',
              style: TextStyle(
                fontSize: 16,
                height: 1.45,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Building code',
                hintText: 'Example: BM-1234',
                prefixIcon: Icon(Icons.qr_code_2_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _joinBuilding,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login_rounded),
                label: Text(_isSubmitting ? 'Joining...' : 'Join building'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinBuilding() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your building code.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(buildingRepositoryProvider)
          .joinBuilding(JoinBuildingRequest(code: code));

      ref.invalidate(myBuildingProvider);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not join building. Please check the code.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
