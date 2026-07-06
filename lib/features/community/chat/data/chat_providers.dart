import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/realtime/realtime_client_factory.dart';
import '../../../../core/storage/token_storage_provider.dart';
import '../../../../core/user/current_user_provider.dart';

import '../domain/chat_repository.dart';
import '../presentation/state/chat_state.dart';
import '../presentation/state/chat_state_notifier.dart';

import 'chat_endpoint_resolver.dart';
import 'chat_repository_impl.dart';
import 'datasource/local/chat_cache.dart';
import 'datasource/remote/chat_api_client.dart';
import 'datasource/remote/chat_websocket_service.dart';

final chatApiClientProvider = Provider<ChatApiClient>((ref) {
  final currentUser = ref.watch(currentUserProvider).valueOrNull;

  if (currentUser == null) {
    throw StateError('Current user must be loaded before opening chat.');
  }

  final basePath = ChatEndpointResolver.messagesEndpoint(currentUser.role);

  return ChatApiClient(dio: ref.watch(dioProvider), basePath: basePath);
});

final chatCacheProvider = Provider<ChatCache>((ref) {
  return ChatCache();
});

final realtimeClientFactoryProvider = Provider<RealtimeClientFactory>((ref) {
  return RealtimeClientFactory(ref.watch(tokenStorageProvider));
});

final chatWebSocketServiceProvider = Provider<ChatWebSocketService>((ref) {
  final service = ChatWebSocketService(
    ref.watch(realtimeClientFactoryProvider),
  );

  ref.onDispose(service.dispose);

  return service;
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    apiClient: ref.watch(chatApiClientProvider),
    webSocketService: ref.watch(chatWebSocketServiceProvider),
    cache: ref.watch(chatCacheProvider),
  );
});

final chatStateNotifierProvider =
    StateNotifierProvider.autoDispose<ChatStateNotifier, ChatState>((ref) {
      return ChatStateNotifier(repository: ref.watch(chatRepositoryProvider));
    });
