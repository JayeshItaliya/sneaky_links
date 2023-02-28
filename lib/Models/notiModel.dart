class NotiModel {
  NotiModel({
    required this.userId,
    required this.username,
    this.profilePicture,
    required this.message,
    required this.notificationType,
    required this.createdAt
  });

  int userId;
  String username;
  dynamic profilePicture;
  String message;
  int notificationType;
  int createdAt;


  factory NotiModel.fromJson(Map<String, dynamic> json) => NotiModel(
    userId: json["userId"],
    username: json["username"],
    profilePicture: json["profilePicture"]??"",
    message: json["message"],
    notificationType: json["notificationType"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "username": username,
    "profilePicture": profilePicture,
    "message": message,
    "notificationType": notificationType,
    "createdAt": createdAt,
  };
  static List<NotiModel> getListFromJson(List<dynamic> list) {
    List<NotiModel> vList = [];
    list.forEach((unit) => vList.add(NotiModel.fromJson(unit)));
    return vList;
  }
}
