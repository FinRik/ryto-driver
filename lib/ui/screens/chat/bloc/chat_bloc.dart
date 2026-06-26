import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../../core/models/chat/chat_message.dart';
import '../../../../core/models/chat/conversation.dart';
import '../../../../core/repos/chat_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  final ChatRepo _repository;
  StreamSubscription? _messageSubscription;

  ChatBloc(this._repository) : super(ChatState()) {
    on<InitiateChat>(_onInitiateChat);
    on<LoadConversations>(_onLoadConversation);
    on<SendMessage>(_onSendMessage);
    on<_OnNewMessageReceived>(_onNewMessageReceived);
  }

  Future<void> _onInitiateChat(
    InitiateChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      // 1. Get or Create (Condition: Init only once)
      final conversation = await _repository.getOrCreateConversation(
        tripId: event.tripId,
        participantIds: event.participantIds,
      );

      // 2. Fetch History
      final history = await _repository.getMessageHistory(conversation.id);

      // 3. Connect to Socket
      _repository.joinConversation(conversation.id);

      // 4. Listen for real-time updates
      _messageSubscription?.cancel();
      _messageSubscription = _repository.messageStream.listen((msg) {
        if (msg.conversationId == conversation.id) {
          add(_OnNewMessageReceived(msg));
        }
      });

      emit(
        state.copyWith(
          status: ChatStatus.success,
          conversation: conversation,
          messages: history,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ChatStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLoadConversation(
    LoadConversations event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final result = await _repository.getConversations();
      emit(state.copyWith(status: ChatStatus.success, conversations: result));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.failure));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    if (state.conversation != null) {
      _repository.sendMessage(state.conversation!.id, event.content);
    }
  }

  // void _onNewMessageReceived(
  //   _OnNewMessageReceived event,
  //   Emitter<ChatState> emit,
  // ) {
  //   // Add new message to the top of the list
  //   final updatedMessages = List<ChatMessage>.from(state.messages)
  //     ..insert(0, event.message);
  //   emit(state.copyWith(messages: updatedMessages));
  // }

  void _onNewMessageReceived(
    _OnNewMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    final bool messageExists = state.messages.any(
      (msg) => msg.id == event.message.id,
    );

    if (!messageExists) {
      final updatedMessages = List<ChatMessage>.from(state.messages)
        ..insert(0, event.message);
      emit(state.copyWith(messages: updatedMessages));
    }
  }

  // --- HydratedBloc Persistence ---
  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    try {
      return ChatState(
        status: ChatStatus.success,
        messages: (json['messages'] as List)
            .map((m) => ChatMessage.fromJson(m))
            .toList(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) {
    return {
      'messages': state.messages
          .map(
            (m) => {
              'id': m.id,
              'content': m.content,
              'messageType': m.messageType,
              'sender': {
                'id': m.sender.id,
                'firstName': m.sender.firstName,
                'lastName': m.sender.lastName,
              },
              'conversationId': m.conversationId,
              'createdAt': m.createdAt.toIso8601String(),
            },
          )
          .toList(),
    };
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
