import '../../../../core/user/user_role.dart';

class ChatEndpointResolver {
  const ChatEndpointResolver._();

  static String messagesEndpoint(UserRole role) {
    return switch (role) {
      UserRole.manager => '/manager/chat/messages',
      UserRole.tenant => '/tenant/chat/messages',
      UserRole.admin => '/admin/chat/messages',
    };
  }
}
