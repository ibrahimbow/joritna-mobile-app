import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../tenant/building/data/building_providers.dart';
import '../../../profile/data/profile_providers.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../data/chat_providers.dart';
import 'chat_texts.dart';
import 'state/chat_scroll_controller.dart';
import 'widgets/chat_connection_status_chip.dart';
import 'widgets/chat_message_composer.dart';
import 'widgets/chat_message_list.dart';
import 'widgets/chat_reaction_picker.dart';
import '../../../../core/file/file_url_resolver.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final ChatScrollController _scrollController;

  String? _initializedBuildingId;
  int? _lastMessageCount;

  @override
  void initState() {
    super.initState();
    _scrollController = ChatScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buildingState = ref.watch(myBuildingProvider);
    final profileState = ref.watch(profileProvider);
    final chatState = ref.watch(chatStateNotifierProvider);
    final chatNotifier = ref.read(chatStateNotifierProvider.notifier);

    ref.listen(chatStateNotifierProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      final previousCount = previous?.messages.length ?? 0;
      final nextCount = next.messages.length;

      if (nextCount > previousCount || nextCount != _lastMessageCount) {
        _lastMessageCount = nextCount;
        _scrollController.scrollToBottomAfterFrame();
      }
    });

    return AppShell(
      selectedIndex: 3,
      child: buildingState.when(
        loading: () => const _ChatPageScaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) =>
            const _ChatPageScaffold(body: _ChatUnavailableState()),
        data: (building) {
          return profileState.when(
            loading: () => const _ChatPageScaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) =>
                const _ChatPageScaffold(body: _ChatUnavailableState()),
            data: (profile) {
              final buildingId = building.id;
              final currentUserId = profile.id;

              if (_initializedBuildingId != buildingId) {
                _initializedBuildingId = buildingId;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  chatNotifier.initialize(
                    buildingId: buildingId,
                    currentUserId: currentUserId,
                  );
                });
              }

              return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: const Color(0xFFF4F7FB),
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  titleSpacing: 16,
                  title: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
                          ),
                        ),
                        child: const Icon(
                          Icons.forum_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ChatTexts.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0F172A),
                                  ),
                            ),
                            const SizedBox(height: 4),
                            ChatConnectionStatusChip(
                              status: chatState.connectionStatus,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFF8FAFC), Color(0xEEF1F5FF)],
                            ),
                          ),
                          child: RefreshIndicator(
                            onRefresh: () => chatNotifier.refresh(buildingId),
                            child: ChatMessageList(
                              messages: chatState.messages,
                              loading: chatState.loading,
                              currentUserId: chatState.currentUserId,
                              scrollController:
                                  _scrollController.scrollController,
                              resolveFileUrl: _resolveFileUrl,
                              onDeleteMessage: chatNotifier.deleteMessage,
                              onReactionTap: (messageId, emoji) {
                                chatNotifier.toggleReaction(
                                  messageId: messageId,
                                  emoji: emoji,
                                );
                              },
                              onLongPressMessage: (_) {},
                            ),
                          ),
                        ),
                      ),
                      ChatMessageComposer(
                        sending: chatState.sending,
                        onSend: (content) {
                          chatNotifier.sendMessage(content: content);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _resolveFileUrl(String? url) {
    return FileUrlResolver.resolve(url);
  }

  void _showReactionPicker({required String messageId}) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              heightFactor: 1,
              child: ChatReactionPicker(
                onReactionSelected: (emoji) {
                  Navigator.of(context).pop();

                  ref
                      .read(chatStateNotifierProvider.notifier)
                      .toggleReaction(messageId: messageId, emoji: emoji);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChatPageScaffold extends StatelessWidget {
  const _ChatPageScaffold({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text(ChatTexts.title)),
        body: body,
      ),
    );
  }
}

class _ChatUnavailableState extends StatelessWidget {
  const _ChatUnavailableState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'Chat is not available right now.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
