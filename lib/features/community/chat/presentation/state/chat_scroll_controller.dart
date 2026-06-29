import 'package:flutter/widgets.dart';

class ChatScrollController {
  ChatScrollController();

  final ScrollController scrollController = ScrollController();

  bool get hasClients => scrollController.hasClients;

  void scrollToBottom({Duration duration = const Duration(milliseconds: 250)}) {
    if (!scrollController.hasClients) {
      return;
    }

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: duration,
      curve: Curves.easeOutCubic,
    );
  }

  void jumpToBottom() {
    if (!scrollController.hasClients) {
      return;
    }

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void scrollToBottomAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  void dispose() {
    scrollController.dispose();
  }
}
