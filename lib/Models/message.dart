import 'dart:convert';

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final int createdAt;

  const Message(this.senderId,this.receiverId, this.message, this.createdAt);

  bool isUserMessage(String senderName) => senderId == senderName;

  String toJson() => json.encode({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'createdAt': createdAt,
      });

  static Message fromJson(Map<String, dynamic> data) {
    return Message(
      data['senderId'],
      data['receiverId'],
      data['message'],
      data['createdAt'],
    );
  }
}
