import 'dart:async';

import '../models/chat/chat_message.dart';
import '../models/chat/conversation.dart';
import '../services/chat_service.dart';

// abstract class ChatRepo {
//   Future<Conversation> getOrCreateConversation(
//     int tripId,
//     List<int> participantIds,
//   );
//   Future<List<Conversation>> getConversations();
//   Future<List<ChatMessage>> getMessageHistory(int conversationId);
//   void sendMessage(int conversationId, String content);
//   void joinConversation(int conversationId);
//   Stream<ChatMessage> get onNewMessage;
// }
//
// class ChatRepoImpl implements ChatRepo {
//   final ChatService _chatService;
//   final SocketService _socketService;
//
//   ChatRepoImpl({
//     required ChatService chatService,
//     required SocketService socketService,
//   }) : _chatService = chatService,
//        _socketService = socketService;
//
//   @override
//   Future<Conversation> getOrCreateConversation(
//     int tripId,
//     List<int> participantIds,
//   ) async {
//     final result = await _chatService.getOrCreateConversation(
//       tripId: tripId,
//       participantIds: participantIds,
//     );
//
//     return result;
//   }
//
//   @override
//   Future<List<Conversation>> getConversations() async {
//     final result = await _chatService.getConversations();
//     return result;
//   }
//
//   @override
//   Future<List<ChatMessage>> getMessageHistory(int conversationId) async {
//     final result = await _chatService.getMessageHistory(conversationId);
//     return result;
//   }
//
//   @override
//   Stream<ChatMessage> get onNewMessage =>
//       _socketService.messageStream.map((data) => ChatMessage.fromJson(data));
//
//   @override
//   void sendMessage(int conversationId, String content) {
//     _socketService.socket.emit('chat:send', {
//       'conversationId': conversationId,
//       'content': content,
//     });
//   }
//
//   @override
//   void joinConversation(int conversationId) {
//     _socketService.socket.emit('chat:join', {'conversationId': conversationId});
//   }
// }

abstract class ChatRepo {
  // REST Methods
  Future<Conversation> getOrCreateConversation({
    required int tripId,
    required List<int> participantIds,
  });
  Future<List<Conversation>> getConversations();
  Future<List<ChatMessage>> getMessageHistory(int conversationId);

  // Socket Methods
  Stream<ChatMessage> get messageStream;
  void joinConversation(int conversationId);
  void sendMessage(int conversationId, String content);
  void dispose();
}

class ChatRepoImpl implements ChatRepo {
  final ChatService _chatService;

  ChatRepoImpl(this._chatService);

  // --- Real-time Logic ---

  /// Exposes the socket stream from the service to the UI
  @override
  Stream<ChatMessage> get messageStream => _chatService.onNewMessage;

  @override
  void joinConversation(int conversationId) {
    _chatService.joinConversation(conversationId);
  }

  @override
  void sendMessage(int conversationId, String content) {
    _chatService.sendMessage(conversationId, content);
  }

  // --- Data Logic ---

  @override
  Future<Conversation> getOrCreateConversation({
    required int tripId,
    required List<int> participantIds,
  }) async {
    try {
      // Fetch all to satisfy condition: "check if a conversation contains the tripId"
      final conversations = await _chatService.getConversations();

      // Check for existing tripId
      final existing = conversations.cast<Conversation?>().firstWhere(
            (conv) => conv?.tripId == tripId,
        orElse: () => null,
      );

      if (existing != null) return existing;

      // Otherwise initialize once
      return await _chatService.createConversation(tripId, participantIds);
    } catch (e) {
      throw Exception("Could not initialize chat: $e");
    }
  }

  @override
  Future<List<Conversation>> getConversations() async {
    try {
      final conversations = await _chatService.getConversations();
      return conversations;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ChatMessage>> getMessageHistory(int conversationId) async {
    return await _chatService.fetchMessageHistory(conversationId);
  }

  @override
  void dispose() {
    _chatService.dispose();
  }
}
