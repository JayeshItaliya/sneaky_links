
class ViewersModel {
  ViewersModel({
    required this.userId,
    required this.username,
    required this.profilePicture,
  });

  int userId;
  String username;
  dynamic profilePicture;

  factory ViewersModel.fromJson(Map<String, dynamic> json) => ViewersModel(
    userId: json["userId"],
    username: json["username"],
    profilePicture: json["profilePicture"]??"",
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "username": username,
    "profilePicture": profilePicture,
  };

  static List<ViewersModel> getListFromJson(List<dynamic> list) {
    List<ViewersModel> vList = [];
    list.forEach((unit) => vList.add(ViewersModel.fromJson(unit)));
    return vList;
  }
}
