class UserData {
  UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.profilePicture,
    this.description,
    this.age,
    this.location,
    this.height,
    this.gender,
    this.education,
    this.ethnicity,
    this.bodyType,
    this.income,
    this.partyFavor,
    this.interestIn,
    required this.isPublicProfile,
    required this.notificationSettings,
    required this.authentication,
  });

  String id;
  String username;
  String email;
  String phone;
  dynamic profilePicture;
  dynamic description;
  dynamic age;
  dynamic location;
  dynamic height;
  dynamic gender;
  dynamic education;
  dynamic ethnicity;
  dynamic bodyType;
  dynamic income;
  dynamic partyFavor;
  dynamic interestIn;
  bool isPublicProfile;
  bool notificationSettings;
  Authentication authentication;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["userId"].toString(),
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        profilePicture: json["profilePicture"] ?? "",
        description: json["description"] ?? "",
        age: json["age"],
        location: json["location"] ?? "",
        height: json["height"],
        gender: json["gender"],
        education: json["education"] ?? "",
        ethnicity: json["ethnicity"] ?? "",
        bodyType: json["bodyType"] ?? "",
        income: json["income"],
        partyFavor: json["partyFavor"],
        interestIn: json["interestIn"],
        isPublicProfile: json["isPublicProfile"],
        notificationSettings: json["notificationSettings"],
        authentication: Authentication.fromJson(json["authentication"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": id,
        "username": username,
        "email": email,
        "phone": phone,
        "profilePicture": profilePicture,
        "description": description,
        "age": age,
        "location": location,
        "height": height,
        "gender": gender,
        "education": education,
        "ethnicity": ethnicity,
        "bodyType": bodyType,
        "income": income,
        "partyFavor": partyFavor,
        "interestIn": interestIn,
        "isPublicProfile": isPublicProfile,
        "notificationSettings": notificationSettings,
        "authentication": authentication.toJson(),
      };
}

class Authentication {
  Authentication({
    required this.accessToken,
    required this.refreshToken,
    required this.expireAt,
  });

  String accessToken;
  String refreshToken;
  int expireAt;

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        expireAt: json["expireAt"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "expireAt": expireAt,
      };
}

class UProfile {
  UProfile({
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.profilePicture,
    required this.description,
    required this.age,
    // required this.work,
    required this.location,
    required this.zipcode,
    required this.height,
    required this.endowmentHeight,
    required this.endowmentWidth,
    required this.gender,
    required this.education,
    required this.ethnicity,
    required this.bodyType,
    required this.income,
    required this.partyFavor,
    required this.interestIn,
    required this.deviceToken,
    required this.interests,
    required this.photos,
    required this.isPublicProfile,
    required this.isLiked,
    required this.isBlocked,
    required this.notificationSettings,
    required this.work,
    required this.joinDate,
    required this.totalLikes,
    required this.totalPosts,
  });

  int userId;
  String username;
  String email;
  String phone;
  dynamic profilePicture;
  dynamic description;
  dynamic age;
  dynamic location;
  dynamic zipcode;
  dynamic height;
  dynamic endowmentHeight;
  dynamic endowmentWidth;
  dynamic gender;
  dynamic education;
  dynamic ethnicity;
  dynamic bodyType;
  dynamic income;
  dynamic partyFavor;
  dynamic interestIn;
  dynamic deviceToken;
  List<dynamic> interests;
  List<dynamic> photos;
  bool isPublicProfile;
  bool isLiked;
  bool isBlocked;
  bool notificationSettings;
  dynamic work;
  dynamic joinDate;
  int totalLikes;
  int totalPosts;

  factory UProfile.fromJson(Map<String, dynamic> json) => UProfile(
        userId: json["userId"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        profilePicture: json["profilePicture"] ?? "",
        description: json["description"] ?? "",
        age: json["age"] ?? "",
        // work: json["work"]??"",
        location: json["location"] ?? "",
        zipcode: json["zipcode"] ?? "",
        height: json["height"] ?? "",
        endowmentHeight: json["endowmentHeight"] ?? "",
        endowmentWidth: json["endowmentWidth"] ?? "",
        gender: json["gender"] ?? "",
        education: json["education"] ?? "",
        ethnicity: json["ethnicity"] ?? "",
        bodyType: json["bodyType"] ?? "",
        income: json["income"] ?? "",
        partyFavor: json["partyFavor"],
        interestIn: json["interestIn"] ?? "",
        deviceToken: json["deviceToken"] ?? "",
        interests: List<dynamic>.from(json["interests"].map((x) => x)),
        photos: List<dynamic>.from(json["photos"].map((x) => x)),
        isPublicProfile: json["isPublicProfile"],
        isLiked: json["isLiked"],
        isBlocked: json["isBlocked"],
        notificationSettings: json["notificationSettings"],
        work: json["work"]??"",
        joinDate: json["joinDate"]??"",
        totalLikes: json["totalLikes"] ?? 0,
        totalPosts: json["totalPosts"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "isLiked": isLiked,
        "isBlocked": isBlocked,
        "userId": userId,
        "username": username,
        "email": email,
        "phone": phone,
        "profilePicture": profilePicture,
        "description": description,
        "age": age,
        // "work": work,
        "location": location,
        "zipcode": zipcode,
        "height": height,
        "endowmentHeight": endowmentHeight,
        "endowmentWidth": endowmentWidth,
        "gender": gender,
        "income": income,
        "partyFavor": partyFavor,
        "interestIn": interestIn,
        "deviceToken": deviceToken,
        "interests": List<dynamic>.from(interests.map((x) => x)),
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "isPublicProfile": isPublicProfile,
        "notificationSettings": notificationSettings,
        "work": work,
        "joinDate": joinDate,
        "totalLikes": totalLikes,
        "totalPosts": totalPosts,
      };
}

class GetProfile {
  GetProfile({
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.profilePicture,
    required this.description,
    required this.age,
    required this.location,
    required this.zipcode,
    required this.height,
    required this.endowmentHeight,
    required this.endowmentWidth,
    required this.gender,
    required this.education,
    required this.ethnicity,
    required this.bodyType,
    required this.income,
    required this.partyFavor,
    required this.interestIn,
    required this.photos,
    required this.deviceToken,
    required this.interests,
    required this.isPublicProfile,
    required this.notificationSettings,
    required this.work,
    required this.joinDate,
    required this.totalLikes,
    required this.totalPosts,
  });

  int userId;
  String username;
  String email;
  String phone;
  dynamic profilePicture;
  dynamic description;
  dynamic age;
  dynamic location;
  dynamic zipcode;
  dynamic height;
  dynamic endowmentHeight;
  dynamic endowmentWidth;
  dynamic gender;
  dynamic education;
  dynamic ethnicity;
  dynamic bodyType;
  dynamic income;
  dynamic partyFavor;
  dynamic interestIn;
  dynamic deviceToken;
  List<dynamic> interests;
  List<dynamic> photos;
  bool isPublicProfile;
  bool notificationSettings;
  dynamic work;
  dynamic joinDate;
  int totalLikes;
  int totalPosts;

  factory GetProfile.fromJson(Map<String, dynamic> json) => GetProfile(
        userId: json["userId"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        profilePicture: json["profilePicture"] ?? "",
        description: json["description"] ?? "",
        age: json["age"] ?? "",
        location: json["location"] ?? "",
        zipcode: json["zipcode"] ?? "",
        height: json["height"] ?? "",
        endowmentHeight: json["endowmentHeight"] ?? "",
        endowmentWidth: json["endowmentWidth"] ?? "",
        gender: json["gender"] ?? "",
        education: json["education"] ?? "",
        ethnicity: json["ethnicity"] ?? "",
        bodyType: json["bodyType"] ?? "",
        income: json["income"] ?? "",
        partyFavor: json["partyFavor"],
        interestIn: json["interestIn"] ?? "",
        deviceToken: json["deviceToken"] ?? "",
        interests: List<dynamic>.from(json["interests"].map((x) => x)),
        photos: List<dynamic>.from(json["photos"].map((x) => x)),
        isPublicProfile: json["isPublicProfile"],
        notificationSettings: json["notificationSettings"],
        work: json["work"]??"",
        joinDate: json["joinDate"]??"",
        totalLikes: json["totalLikes"] ?? 0,
        totalPosts: json["totalPosts"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "email": email,
        "phone": phone,
        "profilePicture": profilePicture,
        "description": description,
        "age": age,
        "location": location,
        "zipcode": zipcode,
        "height": height,
        "endowmentHeight": endowmentHeight,
        "endowmentWidth": endowmentWidth,
        "gender": gender,
        "income": income,
        "partyFavor": partyFavor,
        "interestIn": interestIn,
        "deviceToken": deviceToken,
        "interests": List<dynamic>.from(interests.map((x) => x)),
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "isPublicProfile": isPublicProfile,
        "notificationSettings": notificationSettings,
        "work": work,
        "joinDate": joinDate,
        "totalLikes": totalLikes,
        "totalPosts": totalPosts,
      };
}

class BodyType {
  BodyType({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory BodyType.fromJson(Map<String, dynamic> json) => BodyType(
        id: json["id"],
        name: json["name"],
      );
}

class DynamicModel {
  DynamicModel({
    required this.ethnicity,
    required this.education,
    required this.bodytype,
    required this.interestIn,
  });

  List<dynamic> ethnicity;
  List<dynamic> education;
  List<dynamic> bodytype;
  List<dynamic> interestIn;

  factory DynamicModel.fromJson(Map<String, dynamic> json) => DynamicModel(
        ethnicity: json["ethnicity"] ?? "",
        education: json["education"] ?? "",
        bodytype: json["bodyType"] ?? "",
        interestIn: json["interestIn"] ?? "",
      );
}
