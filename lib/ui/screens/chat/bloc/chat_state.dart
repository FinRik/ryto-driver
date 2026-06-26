part of "chat_bloc.dart";

enum ChatStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<Conversation> conversations;
  final List<ChatMessage> messages;
  final Conversation? conversation;
  final String? errorMessage;
  // final bool isSending;

  const ChatState({
    this.status = ChatStatus.initial,
    this.conversations = const [],
    this.messages = const [],
    this.conversation,
    this.errorMessage,
    // this.isSending = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<Conversation>? conversations,
    List<ChatMessage>? messages,
    Conversation? conversation,
    String? errorMessage,
    // bool? isSending,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      conversation: conversation ?? this.conversation,
      errorMessage: errorMessage ?? this.errorMessage,
      // isSending: isSending ?? this.isSending,
    );
  }

  // Helper for your UI condition: Filter messages for 1-on-1 view
  List<ChatMessage> filteredMessages(int myId, int partnerId) {
    return messages.where((m) =>
    m.sender.id == myId || m.sender.id == partnerId
    ).toList();
  }

  @override
  List<Object?> get props => [
    status,
    conversations,
    conversation,
    messages,
    errorMessage,
    // isSending,
  ];
}
