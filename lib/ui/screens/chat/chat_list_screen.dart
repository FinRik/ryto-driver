import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/chat/conversation.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../widgets/loaders/circular_indicator.dart';
import 'bloc/chat_bloc.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          switch (state.status) {
            case ChatStatus.loading:
              return const Center(child: CircularIndicator());

            case ChatStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.errorMessage ?? "Failed to load conversations"),
                    TextButton(
                      onPressed: () =>
                          context.read<ChatBloc>().add(LoadConversations()),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );

            case ChatStatus.success:
              if (state.conversations.isEmpty) {
                return const Center(child: Text("No conversations yet"));
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.conversations.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, indent: 80),
                itemBuilder: (context, index) {
                  final convo = state.conversations[index];
                  return _ConversationTile(conversation: convo);
                },
              );

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;

  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<ProfileBloc>().state.user;

    // Logic: Find the participant who is NOT the current user
    final partner = conversation.participants.firstWhere(
      (p) => p.id != currentUser?.id,
      orElse: () => conversation.participants.first,
    );

    return ListTile(
      onTap: () {
        // Navigate to the ChatBottomSheet or ChatScreen
        // sl<ChatBloc>().add(LoadChatHistory(conversation.id));
      },
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: partner.profilePicture != null
            ? NetworkImage(partner.profilePicture!)
            : null,
        child: partner.profilePicture == null
            ? Text(partner.firstName[0].toUpperCase())
            : null,
      ),
      title: Text(
        "${partner.firstName} ${partner.lastName}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        conversation.lastMessage?.content ?? "Start a conversation...",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: conversation.lastMessage != null
              ? FontWeight.normal
              : FontWeight.w300,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (conversation.lastMessage != null)
            Text(
              _formatTime(conversation.updatedAt),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          const SizedBox(height: 4),
          // You could add an unread counter dot here if the API provides it
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    }
    return "${date.day}/${date.month}/${date.year}";
  }
}
