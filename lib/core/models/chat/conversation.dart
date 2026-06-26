import 'chat_message.dart';
import 'chat_participant.dart';

class Conversation {
  final int id;
  final int tripId;
  final List<ChatParticipant> participants;
  final ChatMessage? lastMessage;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.tripId,
    required this.participants,
    this.lastMessage,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      tripId: json['tripId'],
      participants: (json['participants'] as List)
          .map((p) => ChatParticipant.fromJson(p))
          .toList(),
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'])
          : null,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Helper to get the other person's name (useful for the UI title)
  String getChatPartnerDP(int participantId) {
    final partner = participants.firstWhere(
      (p) => p.id == participantId,
      orElse: () => participants.first,
    );
    return "${partner.profilePicture}";
  }

  String getChatPartnerInitials(int participantId) {
    final partner = participants.firstWhere(
      (p) => p.id == participantId,
      orElse: () => participants.first,
    );
    return partner.getChatPartnerInitials;
  }

  String getChatPartnerName(int participantId) {
    final partner = participants.firstWhere(
      (p) => p.id == participantId,
      orElse: () => participants.first,
    );
    return "${partner.firstName} ${partner.lastName}";
  }

  String getChatPartnerRole(int participantId) {
    final partner = participants.firstWhere(
      (p) => p.id == participantId,
      orElse: () => participants.first,
    );
    return "${partner.role}";
  }
}
