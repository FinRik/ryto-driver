class ChatParticipant {
  final int id;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final String? role;

  ChatParticipant({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    this.role,
  });

  String get getChatPartnerInitials => "${firstName[0]}${lastName[0]}";

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
      role: json['role'],
    );
  }
}
