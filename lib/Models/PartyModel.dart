
class PartyModel {
  PartyModel({
    required this.roomId,
    required this.createdBy,
    required this.roomName,
    required this.location,
    required this.price,
    required this.isPasscodeRequiredToJoin,
    required this.coverPhoto,
    required this.participants,
  });

  int roomId;
  int createdBy;
  String roomName;
  String location;
  int price;
  bool isPasscodeRequiredToJoin;
  String coverPhoto;
  List<Participant> participants;

  factory PartyModel.fromJson(Map<String, dynamic> json) => PartyModel(
    roomId: json["roomId"],
    createdBy: json["createdBy"],
    roomName: json["roomName"],
    location: json["location"]??"",
    price: json["price"],
    isPasscodeRequiredToJoin: json["isPasscodeRequiredToJoin"],
    coverPhoto: json["coverPhoto"]??"",
    participants: List<Participant>.from(json["participants"].map((x) => Participant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "roomId": roomId,
    "createdBy": createdBy,
    "roomName": roomName,
    "price": price,
    "isPasscodeRequiredToJoin": isPasscodeRequiredToJoin,
    "coverPhoto": coverPhoto,
    "participants": List<dynamic>.from(participants.map((x) => x.toJson())),
  };

  static List<PartyModel> getListFromJson(List<dynamic> list) {
    List<PartyModel> unitList = [];
    list.forEach((unit) => unitList.add(PartyModel.fromJson(unit)));
    return unitList;
  }

}

class Participant {
  Participant({
    required this.userId,
    required this.username,
    this.profilePicture,
  });

  int userId;
  String username;
  dynamic profilePicture;

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    userId: json["userId"],
    username: json["username"],
    profilePicture: json["profilePicture"]??"",
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "username": username,
    "profilePicture": profilePicture,
  };
}


