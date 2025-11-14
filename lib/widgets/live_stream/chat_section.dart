import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/live_stream_provider.dart';
import '../../models/live_stream.dart';
import '../../utils/app_theme.dart';

class ChatSection extends StatefulWidget {
  final String streamId;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ChatSection({
    super.key,
    required this.streamId,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          if (widget.isExpanded) ...[
            Expanded(child: _buildMessageList()),
            _buildMessageInput(),
          ] else
            _buildCollapsedView(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: widget.onToggle,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              widget.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const Text(
              'Live Chat',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Consumer<LiveStreamProvider>(
              builder: (context, provider, child) {
                return Text(
                  '${provider.messages.length} messages',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return Consumer<LiveStreamProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: provider.messages.length,
          itemBuilder: (context, index) {
            return _buildMessageBubble(provider.messages[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.type == MessageType.system) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.message,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    if (message.type == MessageType.admin) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.divineGold.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.divineGold),
        ),
        child: Text(
          message.message,
          style: const TextStyle(
            color: AppTheme.divineGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Align(
      alignment: message.isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isOwn ? AppTheme.divineGold : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isOwn)
              Text(
                message.userName,
                style: const TextStyle(
                  color: AppTheme.sacredBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            Text(
              message.message,
              style: TextStyle(
                color: message.isOwn ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedView() {
    return Consumer<LiveStreamProvider>(
      builder: (context, provider, child) {
        final recentMessages = provider.messages.take(2).toList();
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ...recentMessages.map((msg) => Text(
                    '${msg.userName}: ${msg.message}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
              const SizedBox(height: 8),
              Text(
                'Tap to view all',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[800],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                counterText: '',
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: AppTheme.sacredBlue),
            onPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                Provider.of<LiveStreamProvider>(context, listen: false)
                    .sendMessage(widget.streamId, _messageController.text.trim());
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
