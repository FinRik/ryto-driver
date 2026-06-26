import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/user/user_entity.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../blocs/profile/profile_bloc.dart';
import '../screens/chat/bloc/chat_bloc.dart';
import '../screens/chat/widgets/chat_bubble.dart';
import '../widgets/layouts/base_bottom_sheet.dart';
import '../widgets/loaders/circular_indicator.dart';

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(
        InitiateChat(
          tripId: widget.request.data['tripId'],
          participantIds: [widget.request.data['participantId']],
        ),
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<ProfileBloc>().state.user;

    return BaseBottomSheet(
      hasScrollableChild: true,
      multiplier: .9,
      builder: (context, size) {
        return BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {},
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (state.conversation != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButton(),
                        CircleAvatar(
                          radius: 16,
                          child: Text(
                            state.conversation!.getChatPartnerInitials(
                              widget.request.data['participantId'],
                            ),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.conversation!.getChatPartnerName(
                                widget.request.data['participantId'],
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              state.conversation!.getChatPartnerRole(
                                widget.request.data['participantId'],
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const Divider(),

                  Expanded(child: _buildMessageList(state, currentUser!)),

                  if (state.status == ChatStatus.success) ...[
                    _buildQuickReplies(context),
                    SizedBox(height: 12),
                    _buildInputArea(context),
                  ],

                  if (state.status == ChatStatus.failure)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(state.errorMessage ?? "Error"),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMessageList(ChatState state, UserEntity currentUser) {
    if (state.status == ChatStatus.loading) {
      return const Center(child: CircularIndicator());
    }

    // Condition 2: Filter to only show messages between "Me" and the "Target Individual"
    // even if the backend room contains other participants.
    final partnerId = widget.request.data['participantId'];
    final displayMessages = state.filteredMessages(currentUser.id, partnerId);

    if (displayMessages.isEmpty && state.status == ChatStatus.success) {
      return const Center(child: Text("No messages yet."));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      reverse: true,
      itemCount: displayMessages.length,
      itemBuilder: (context, index) {
        final message = displayMessages[index];
        final bool isMe = message.sender.id == currentUser.id;
        return ChatBubble(message: message, isMe: isMe);
      },
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: "Type a message...",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: IconButton(
            onPressed: _handleSend,
            icon: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  void _handleSend() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(_messageController.text.trim()));
      _messageController.clear();
    }
  }

  Widget _buildQuickReplies(BuildContext context) {
    final replies = ["I'm outside", "Coming now", "Be right there"];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => ActionChip(
          label: Text(replies[i], style: const TextStyle(fontSize: 12)),
          onPressed: () =>
              context.read<ChatBloc>().add(SendMessage(replies[i])),
        ),
      ),
    );
  }
}
