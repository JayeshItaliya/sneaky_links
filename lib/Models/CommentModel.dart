class CommentModel {
  CommentModel({
    required this.commentId,
    required this.userId,
    required this.username,
    required this.comment,
    this.profilePicture,
    required this.isLikedByMe,
    required this.totalLikes,
    required this.createdAt,
  });

  int commentId;
  int userId;
  String username;
  String comment;
  dynamic profilePicture;
  int isLikedByMe;
  int totalLikes;
  int createdAt;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    commentId: json["commentId"],
    userId: json["userId"],
    username: json["username"],
    comment: json["comment"],
    profilePicture: json["profilePicture"]??"",
    isLikedByMe: json["isLikedByMe"],
    totalLikes: json["totalLikes"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "commentId": commentId,
    "userId": userId,
    "username": username,
    "comment": comment,
    "profilePicture": profilePicture,
    "isLikedByMe": isLikedByMe,
    "totalLikes": totalLikes,
    "createdAt": createdAt,
  };

  static List<CommentModel> getListFromJson(List<dynamic> list) {
    List<CommentModel> unitList = [];
    list.forEach((unit) => unitList.add(CommentModel.fromJson(unit)));
    return unitList;
  }

}

class CommentRModel {
  CommentRModel({
    required this.commentReplyId,
    required this.userId,
    required this.username,
    required this.comment,
    required this.profilePicture,
    required this.createdAt,
  });

  int commentReplyId;
  int userId;
  String username;
  String comment;
  String profilePicture;
  int createdAt;

  factory CommentRModel.fromJson(Map<String, dynamic> json) => CommentRModel(
    commentReplyId: json["commentReplyId"],
    userId: json["userId"],
    username: json["username"],
    comment: json["comment"],
    profilePicture: json["profilePicture"]??"",
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "commentReplyId": commentReplyId,
    "userId": userId,
    "username": username,
    "comment": comment,
    "profilePicture": profilePicture,
    "createdAt": createdAt,
  };
  static List<CommentRModel> getListFromJson(List<dynamic> list) {
    List<CommentRModel> unitList = [];
    list.forEach((unit) => unitList.add(CommentRModel.fromJson(unit)));
    return unitList;
  }
}
