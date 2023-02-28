
class ChatModel {
  ChatModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.media,
    this.mediaThumbnail,
    required this.messageType,
    required this.createdAt,
  });

  int messageId;
  int senderId;
  int receiverId;
  String message;
  dynamic media;
  dynamic mediaThumbnail;
  int messageType;
  int createdAt;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    messageId: json["messageId"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    message: json["message"]??"",
    media: json["media"]??"",
    mediaThumbnail: json["mediaThumbnail"]??"",
    messageType: json["messageType"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "senderId": senderId,
    "receiverId": receiverId,
    "message": message,
    "media": media,
    "mediaThumbnail": mediaThumbnail,
    "messageType": messageType,
    "createdAt": createdAt,
  };
  static List<ChatModel> getListFromJson(List<dynamic> list) {
    List<ChatModel> unitList = [];
    list.forEach((unit) => unitList.add(ChatModel.fromJson(unit)));
    return unitList;
  }

}
