class ConferencesItemReport {
  //Variables
  String? id;
  String? Name;
  String? presentBy;
  String? confDate;
  String? confTime;
  String? confPlace;

  //Constructor
  ConferencesItemReport({
    required this.id,
    required this.Name,
    required this.presentBy,
    required this.confDate,
    required this.confTime,
    required this.confPlace,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ConfName'] = Name;
    map['PresentBy'] = presentBy;
    map['ConfDate'] = confDate;
    map['ConfTime'] = confTime;
    map['ConfPlace'] = confPlace;
    return map;
  }
}
