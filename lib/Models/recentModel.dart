
class RecentModel {
  RecentModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.username,
    required this.profilePicture,
    required this.message,
    this.media,
    this.mediaThumbnail,
    required this.messageType,
    required this.unreadMessageCount,
    required this.isOnline,
    required this.createdAt,
  });

  int messageId;
  int senderId;
  int receiverId;
  String username;
  dynamic profilePicture;
  String message;
  dynamic media;
  dynamic mediaThumbnail;
  int messageType;
  int unreadMessageCount;
  bool isOnline;
  int createdAt;

  factory RecentModel.fromJson(Map<String, dynamic> json) => RecentModel(
    messageId: json["messageId"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    username: json["username"],
    profilePicture: json["profilePicture"]??"",
    message: json["message"],
    media: json["media"],
    mediaThumbnail: json["mediaThumbnail"],
    messageType: json["messageType"],
    unreadMessageCount: json["unreadMessageCount"],
    isOnline: json["isOnline"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "senderId": senderId,
    "receiverId": receiverId,
    "username": username,
    "profilePicture": profilePicture,
    "message": message,
    "media": media,
    "mediaThumbnail": mediaThumbnail,
    "messageType": messageType,
    "unreadMessageCount": unreadMessageCount,
    "isOnline": isOnline,
    "createdAt": createdAt,
  };
  static List<RecentModel> getListFromJson(List<dynamic> list) {
    List<RecentModel> vList = [];
    list.forEach((unit) => vList.add(RecentModel.fromJson(unit)));
    return vList;
  }
}
