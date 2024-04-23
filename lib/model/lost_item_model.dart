class LostItemModel {
  //Variables
  String? id;
  String? photo;
  String? category;
  String? lostDate;
  String? expectedPlace;
  String? phoneNumber;
  String? desription;
  String? creatorID;

  //Constructor
  LostItemModel({
    required this.id,
    required this.photo,
    required this.category,
    required this.lostDate,
    required this.expectedPlace,
    required this.phoneNumber,
    required this.desription,
    required this.creatorID,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['category'] = category;
    map['lostDate'] = lostDate;
    map['expectedPlace'] = expectedPlace;
    map['description'] = desription;
    map['photo'] = photo;
    map['creatorID'] = creatorID;

    return map;
  }
}
