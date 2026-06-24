import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/presentation/layout/app_shell.dart';

class ChatTheme {
  const ChatTheme._();
  static const Color primaryBlue = Color(0xFF0057C8);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color bubbleMe = Color(0xFFE2EBFB);
  static const Color bubbleOther = Color(0xFFF1F5F9);
}

class ChatMessage {
  final String id;
  final String senderName;
  final String? text;
  final String? localImagePath;
  final bool isMe;
  final String time;
  String? reaction;

  ChatMessage({
    required this.id,
    required this.senderName,
    this.text,
    this.localImagePath,
    required this.isMe,
    required this.time,
    this.reaction,
  });
}

class ChatScreen extends StatefulWidget {
  final String roomTitle;
  const ChatScreen({super.key, this.roomTitle = 'Community Chat'});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker(); // Works perfectly now!

  XFile? _pickedFile; // Works perfectly now!

  final List<ChatMessage> _messages = [];

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? selected = await _picker.pickImage(
        source: ImageSource.gallery, // Works perfectly now!
        imageQuality: 80,
      );
      if (selected != null) {
        setState(() {
          _pickedFile = selected;
        });
      }
    } catch (e) {
      debugPrint("Error fetching gallery image: $e");
    }
  }

  void _clearSelectedImage() {
    setState(() {
      _pickedFile = null;
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty && _pickedFile == null) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderName: "Brimoo",
          text: text.isEmpty ? null : text,
          localImagePath: _pickedFile?.path,
          isMe: true,
          time:
              "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
        ),
      );
      _pickedFile = null;
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _handleReaction(String messageId, String emoji) {
    setState(() {
      final msg = _messages.firstWhere((m) => m.id == messageId);
      msg.reaction = (msg.reaction == emoji) ? null : emoji;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 3,
      backgroundColor: ChatTheme.bgLight,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              widget.roomTitle,
              style: const TextStyle(
                color: ChatTheme.textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet. Long press bubble to react!',
                      style: TextStyle(color: ChatTheme.textMuted),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _ChatBubbleRow(
                        message: _messages[index],
                        onSelectReaction: (emoji) =>
                            _handleReaction(_messages[index].id, emoji),
                      );
                    },
                  ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_pickedFile != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_pickedFile!.path),
                        height: 90,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: _clearSelectedImage,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: ChatTheme.primaryBlue,
                  child: const Text(
                    'B',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ChatTheme.bgLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.image_outlined,
                            color: ChatTheme.textMuted,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: _pickImageFromGallery,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            maxLines: null,
                            style: const TextStyle(
                              color: ChatTheme.textDark,
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Type message or paste emojies...',
                              hintStyle: TextStyle(
                                color: ChatTheme.textMuted,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: ChatTheme.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubbleRow extends StatelessWidget {
  final ChatMessage message;
  final ValueChanged<String> onSelectReaction;

  const _ChatBubbleRow({required this.message, required this.onSelectReaction});

  void _showReactionSheet(BuildContext context) {
    final emojis = ["👍", "❤️", "😂", "😮", "😢", "🙏"];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: emojis
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    onSelectReaction(e);
                    Navigator.pop(context);
                  },
                  child: Text(e, style: const TextStyle(fontSize: 28)),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: ChatTheme.textMuted.withValues(alpha: 0.15),
              child: Text(message.senderName[0]),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onLongPress: () => _showReactionSheet(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: message.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 4,
                        bottom: 4,
                      ),
                      child: Text(
                        message.senderName,
                        style: const TextStyle(
                          color: ChatTheme.textDark,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.65,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message.isMe
                            ? ChatTheme.bubbleMe
                            : ChatTheme.bubbleOther,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: message.isMe
                              ? const Radius.circular(16)
                              : const Radius.circular(4),
                          bottomRight: message.isMe
                              ? const Radius.circular(4)
                              : const Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: message.isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (message.localImagePath != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(File(message.localImagePath!)),
                            ),
                            if (message.text != null) const SizedBox(height: 8),
                          ],
                          if (message.text != null)
                            Text(
                              message.text!,
                              style: const TextStyle(
                                color: ChatTheme.textDark,
                                fontSize: 14.5,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            message.time,
                            style: const TextStyle(
                              color: ChatTheme.textMuted,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (message.reaction != null)
                  Positioned(
                    bottom: -10,
                    right: message.isMe ? null : -4,
                    left: message.isMe ? -4 : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        message.reaction!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: ChatTheme.primaryBlue.withValues(alpha: 0.15),
              child: const Text('B'),
            ),
          ],
        ],
      ),
    );
  }
}
