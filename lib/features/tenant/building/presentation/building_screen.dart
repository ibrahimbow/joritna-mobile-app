import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joritna_mobile/core/user/user_role.dart';

import '../../../../core/errors/failure.dart';
import '../../../profile/data/profile_providers.dart';
import '../../../shared/presentation/dashboard/widgets/dashboard_header.dart';
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
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return profileState.when(
      loading: () => const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      ),
      error: (_, __) => Scaffold(
        body: _JoinBuildingContent(
          displayName: 'Resident',
          role: UserRole.tenant,
          avatarUrl: null,
          codeController: _codeController,
          isSubmitting: _isSubmitting,
          errorMessage: _errorMessage,
          onJoinBuilding: _joinBuilding,
        ),
      ),
      data: (profile) => Scaffold(
        body: _JoinBuildingContent(
          displayName: profile.displayName,
          role: profile.role,
          avatarUrl: profile.avatarUrl,
          codeController: _codeController,
          isSubmitting: _isSubmitting,
          errorMessage: _errorMessage,
          onJoinBuilding: _joinBuilding,
        ),
      ),
    );
  }

  Future<void> _joinBuilding() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your building code.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(buildingRepositoryProvider)
          .joinBuilding(JoinBuildingRequest(code: code));

      ref.invalidate(myBuildingProvider);
    } catch (error) {
      if (!mounted) {
        return;
      }

      final failure = Failure.fromException(
        error,
        fallbackMessage: 'Could not join building. Please check the code.',
      );

      setState(() {
        _errorMessage = failure.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class _JoinBuildingContent extends StatelessWidget {
  const _JoinBuildingContent({
    required this.displayName,
    required this.role,
    required this.avatarUrl,
    required this.codeController,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onJoinBuilding,
  });

  final String displayName;
  final UserRole role;
  final String? avatarUrl;
  final TextEditingController codeController;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback onJoinBuilding;

  static const Color _officialBlue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          DashboardHeader(
            displayName: displayName,
            role: role,
            avatarUrl: avatarUrl,
            showSettingsButton: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InformationBox(),
                const SizedBox(height: 24),
                const Text(
                  'Join your building',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter the building code provided by your building manager to access your community.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.45,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: codeController,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (!isSubmitting) {
                      onJoinBuilding();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Building code',
                    hintText: 'Example: BM-1234',
                    prefixIcon: const Icon(Icons.qr_code_2_rounded),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: _officialBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 14),
                  _ErrorBox(message: errorMessage!),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: _officialBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: isSubmitting ? null : onJoinBuilding,
                    icon: isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.login_rounded),
                    label: Text(
                      isSubmitting ? 'Joining...' : 'Join building',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
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

class _InformationBox extends StatelessWidget {
  const _InformationBox();

  static const Color _officialBlue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _officialBlue),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'You are not currently part of a building. Join your building to access announcements, chat, and Share & Help.',
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
