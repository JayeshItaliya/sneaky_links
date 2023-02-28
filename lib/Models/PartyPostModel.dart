class PartyPostModel {
  PartyPostModel({
    required this.postId,
    required this.addedBy,
    required this.username,
    required this.profilePicture,
    required this.postText,
    required this.media,
    // required this.mediaType,
    // required this.mediaThumbnail,
    required this.seconds,
    required this.totalLikes,
    required this.totalComments,
    required this.totalShares,
    required this.isLikedByMe,
    required this.createdAt,
  });

  int postId;
  int addedBy;
  String username;
  String profilePicture;
  String postText;
  String media;
  // int mediaType;
  // String mediaThumbnail;
  int seconds;
  int totalLikes;
  int totalComments;
  int totalShares;
  bool isLikedByMe;
  int createdAt;

  factory PartyPostModel.fromJson(Map<String, dynamic> json) => PartyPostModel(
    postId: json["postId"],
    addedBy: json["addedBy"],
    username: json["username"],
    profilePicture: json["profilePicture"]??"",
    postText: json["postText"],
    media: json["media"]??"",
    // mediaType: json["mediaType"]??"",
    // mediaThumbnail: json["mediaThumbnail"]??"",
    seconds: json["seconds"],
    totalLikes: json["totalLikes"],
    totalComments: json["totalComments"],
    totalShares: json["totalShares"],
    isLikedByMe: json["isLikedByMe"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "addedBy": addedBy,
    "username": username,
    "profilePicture": profilePicture,
    "postText": postText,
    "media": media,
    // "mediaType": mediaType,
    // "mediaThumbnail": mediaThumbnail,
    "seconds": seconds,
    "totalLikes": totalLikes,
    "totalComments": totalComments,
    "totalShares": totalShares,
    "isLikedByMe": isLikedByMe,
    "createdAt": createdAt,
  };
  static List<PartyPostModel> getListFromJson(List<dynamic> list) {
    List<PartyPostModel> unitList = [];
    list.forEach((unit) => unitList.add(PartyPostModel.fromJson(unit)));
    return unitList;
  }
}
