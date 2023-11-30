
class FoundItemReport {
  //Variables
  String? id;
  String? photo;
  String? category;
  String? foundDate;
  String? foundPlace;
  String? receivePlace;
  String? desription;

  //Constructor
  FoundItemReport({
    required this.id,
    required this.photo,
    required this.category,
    required this.foundDate,
    required this.foundPlace,
    required this.receivePlace,
    required this.desription,
  });


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Category'] = category;
    map['FoundDate'] = foundDate;
    map['FoundPlace'] = foundPlace;
    map['ReceivePlace'] = receivePlace;
    map['Description'] = desription;
    map['Photo'] = photo;
    return map;
  }
}

