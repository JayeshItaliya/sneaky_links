class HideModel {
  HideModel({
    required this.id,
    required this.userId,
    required this.phone,
  });

  int id;
  int userId;
  String phone;

  factory HideModel.fromJson(Map<String, dynamic> json) => HideModel(
    id: json["id"],
    userId: json["userId"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
  };

  static List<HideModel> getListFromJson(List<dynamic> list) {
    List<HideModel> unitList = [];
    list.forEach((unit) => unitList.add(HideModel.fromJson(unit)));
    return unitList;
  }
}
