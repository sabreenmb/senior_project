import 'package:flutter/foundation.dart';

class FoundItemReport {
  //Variables
  String? id;
  String? photo;
  String? category;
  String? lostDate;
  String? expectedPlace;
  String? desription;

  //Constructor
  FoundItemReport({
    required this.id,
    required this.photo,
    required this.category,
    required this.lostDate,
    required this.expectedPlace,
    required this.desription,
  });
  // ignore: avoid_print
  FoundItemReport.fromJson(Map<String,dynamic> json) {
    category=json['Category'];
    lostDate=json['LostDate'];
    expectedPlace = json['ExpectedPlace'];
    desription = json['Description'];
    photo = json['PhotoBase64'];
  }



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Category'] = category;
    map['LostDate'] = lostDate;
    map['ExpectedPlace'] = expectedPlace;
    map['Description'] = desription;
    map['PhotoBase64'] = photo;
    return map;
  }
}

