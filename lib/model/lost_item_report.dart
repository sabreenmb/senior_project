class LostItemReport {
  //Variables
  String? id;
  String? photo;
  String? category;
  String? lostDate;
  String? expectedPlace;
  String? phoneNumber;
  String? desription;

  //Constructor
  LostItemReport({
    required this.id,
    required this.photo,
    required this.category,
    required this.lostDate,
    required this.expectedPlace,
    required this.phoneNumber,
    required this.desription,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PhoneNumber'] = phoneNumber;
    map['Category'] = category;
    map['LostDate'] = lostDate;
    map['ExpectedPlace'] = expectedPlace;
    map['Description'] = desription;
    map['Photo'] = photo;
    return map;
  }
}
