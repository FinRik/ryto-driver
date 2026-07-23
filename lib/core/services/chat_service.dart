import 'dart:async';

import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../app/api_urls.dart';
import '../../utils/storage/token_storage.dart';
import '../models/chat/chat_message.dart';
import '../models/chat/conversation.dart';
import '../models/driver_notification.dart';
import 'push_notification_manager.dart';

class ChatService {
  final Dio _dio;
  io.Socket? _socket;

  // Stream to broadcast new messages as they arrive via socket
  final _messageController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get onNewMessage => _messageController.stream;

  final _notificationController = StreamController<DriverNotification>.broadcast();
  Stream<DriverNotification> get onNotification => _notificationController.stream;

  ChatService(Dio dio) : _dio = dio {
    _initSocket();
  }

  // --- SOCKET LOGIC ---
  Future<void> _initSocket() async {
    final token = await TokenStorage.getAccessToken();
    _socket = io.io(
      '${ApiUrls.baseUrl}/chat',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) => print('Connected to Chat Socket'));

    // Handle incoming messages
    _socket!.on('chat:new-message', (data) {
      try {
        final message = ChatMessage.fromJson(data);
        _messageController.add(message);
      } catch (e) {
        print('Error parsing incoming socket message: $e');
      }
    });

    // Handle connection success confirmation from server
    _socket!.on('chat:connected', (data) {
      print('Server confirmed connection for userId: ${data['userId']}');
    });

    // Handle errors
    _socket!.on(
      'chat:error',
      (data) => print('Socket Error: ${data['message']}'),
    );

    _socket!.on('driver:notification', (data) {
      try {
        if (data is Map<String, dynamic>) {
          final notification = DriverNotification.fromJson(data);

          // 1. Push to in-app stream subscribers (e.g. Blocs, SnackBar overlays)
          _notificationController.add(notification);

          // 2. Trigger native heads-up system notification using your PushNotificationManager
          PushNotificationService().showSocketNotification(notification);
        }
      } catch (e) {
        print('Error handling driver socket notification: $e');
      }
    });

    _socket!.onConnectError((err) => print('Connect Error: $err'));

    _socket!.onDisconnect((_) => print('Disconnected from Chat Socket'));
  }

  /// Sends a request to join a specific conversation room
  void joinConversation(int conversationId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('chat:join', {'conversationId': conversationId});
      print('Joining conversation room: $conversationId');
    }
  }

  /// Sends a message via the socket
  void sendMessage(int conversationId, String content) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('chat:send', {
        'conversationId': conversationId,
        'content': content,
      });
    } else {
      print('Cannot send message: Socket not connected');
    }
  }

  // --- REST API LOGIC ---
  Future<List<Conversation>> getConversations() async {
    final response = await _dio.get('/chat/conversations');
    final List data = response.data['data'];
    return data.map((json) => Conversation.fromJson(json)).toList();
  }

  Future<Conversation> createConversation(
    int tripId,
    List<int> participantIds,
  ) async {
    final response = await _dio.post(
      '/chat/conversations',
      data: {"participantIds": participantIds, "tripId": tripId},
    );
    return Conversation.fromJson(response.data['data']);
  }

  Future<List<ChatMessage>> fetchMessageHistory(int conversationId) async {
    final response = await _dio.get(
      '/chat/conversations/$conversationId/messages',
      queryParameters: {'pageSize': 50, 'page': 1},
    );
    final List items = response.data['data']['items'];
    return items.map((json) => ChatMessage.fromJson(json)).toList();
  }

  void dispose() {
    _socket?.dispose();
    _messageController.close();
    _notificationController.close();
  }
}
