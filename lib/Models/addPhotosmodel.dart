
class AllPhotosModel {
  AllPhotosModel({
    required this.id,
    required this.photo,
  });

  int id;
  String photo;

  factory AllPhotosModel.fromJson(Map<String, dynamic> json) => AllPhotosModel(
    id: json["id"],
    photo: json["photo"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
  };
  static List<AllPhotosModel> getListFromJson(List<dynamic> list) {
    List<AllPhotosModel> unitList = [];
    list.forEach((unit) => unitList.add(AllPhotosModel.fromJson(unit)));
    return unitList;
  }
}
