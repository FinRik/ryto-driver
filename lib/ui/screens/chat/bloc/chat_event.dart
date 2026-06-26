part of "chat_bloc.dart";

abstract class ChatEvent extends Equatable {}

class InitiateChat extends ChatEvent {
  final int tripId;
  final List<int> participantIds;
  InitiateChat({required this.tripId, required this.participantIds});

  @override
  List<Object?> get props => [tripId, participantIds];
}

class SendMessage extends ChatEvent {
  final String content;
  SendMessage(this.content);

  @override
  List<Object?> get props => [content];
}

class _OnNewMessageReceived extends ChatEvent {
  final ChatMessage message;
  _OnNewMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

// class InitializeChat extends ChatEvent {
//   final int tripId;
//   final List<int> participantIds;
//
//   InitializeChat({required this.tripId, required this.participantIds});
//
//   @override
//   List<Object?> get props => [tripId, participantIds];
// }
//
// class SendMessage extends ChatEvent {
//   final int conversationId;
//   final String content;
//
//   SendMessage({required this.conversationId, required this.content});
//
//   @override
//   List<Object?> get props => [conversationId, content];
// }
//
class LoadConversations extends ChatEvent {
  LoadConversations();

  @override
  List<Object?> get props => [];
}
//
// class LoadChatHistory extends ChatEvent {
//   final int conversationId;
//   LoadChatHistory(this.conversationId);
//
//   @override
//   List<Object?> get props => [conversationId];
// }
//
// class ReceiveMessage extends ChatEvent {
//   final ChatMessage message;
//   ReceiveMessage(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }
