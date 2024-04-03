
class OfferInfo {
  //Variables
  String? id;
  String? logo;
  String? category;
  String? code;
  String? details;
  String? discount;
  String? expDate;
  String? contact;
  String? name;
  String?targetUsers;
  String? timestamp;


  //Constructor
  OfferInfo({
    required this.id,
    required this.name,
    required this.logo,
    required this.category,
    required this.code,
    required this.details,
    required this.discount,
    required this.expDate,
    required this.contact,
    required this.targetUsers,
    required this.timestamp,

  });


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['of_category'] = category;
    map['of_code'] = code;
    map['of_contact'] = contact;
    map['timestamp']=timestamp;
    map['of_details'] = details;
    map['of_discount'] = discount;
    map['of_expDate'] = expDate;
    map['of_logo'] = logo;
    map['of_name'] = name;
    map['of_logo'] = logo;
    map['of_target'] = targetUsers;
    return map;
  }
}

