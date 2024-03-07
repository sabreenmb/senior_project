
class SClubInfo {
  //Variables
  String? id;
  String? logo;
  String? regTime;
  String? leader;
  String? details;
  String? contact;
  String? name;
  String?membersLink;
  String? MngLink;

  //Constructor
  SClubInfo({
    required this.id,
    required this.name,
    required this.logo,
    required this.regTime,
    required this.leader,
    required this.details,
    required this.membersLink,
    required this.MngLink,
    required this.contact,
  });


  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['of_category'] = category;
  //   map['of_code'] = code;
  //   map['of_contact'] = contact;
  //
  //   map['of_details'] = details;
  //   map['of_discount'] = discount;
  //   map['of_expDate'] = expDate;
  //   map['of_logo'] = logo;
  //   map['of_name'] = name;
  //   map['of_logo'] = logo;
  //   map['of_target'] = targetUsers;
  //   return map;
  // }
}

