
class UserlikesModel {
  UserlikesModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePicture,
    required this.location,
    required this.age,
  });

  int id;
  String username;
  String email;
  String phone;
  String password;
  dynamic location;
  dynamic age;
  dynamic profilePicture;

  factory UserlikesModel.fromJson(Map<String, dynamic> json) => UserlikesModel(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    profilePicture: json["profilePicture"]??"",
    location: json["location"]??"",
    age: json["age"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone": phone,
    "password": password,
    "profilePicture": profilePicture,
  };


  static List<UserlikesModel> getListFromJson(List<dynamic> list) {
    List<UserlikesModel> unitList = [];
    list.forEach((unit) => unitList.add(UserlikesModel.fromJson(unit)));
    return unitList;
  }
}
class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePicture,
    required this.location,
    required this.age,
  });

  int id;
  String username;
  String email;
  String phone;
  String password;
  dynamic location;
  dynamic age;
  dynamic profilePicture;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["userId"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    profilePicture: json["profilePicture"]??"",
    location: json["location"]??"",
    age: json["age"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone": phone,
    "password": password,
    "profilePicture": profilePicture,
  };


  static List<UserModel> getListFromJson(List<dynamic> list) {
    List<UserModel> unitList = [];
    list.forEach((unit) => unitList.add(UserModel.fromJson(unit)));
    return unitList;
  }
}
