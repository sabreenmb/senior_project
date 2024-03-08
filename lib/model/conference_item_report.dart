class ConferencesItemReport {
  //Variables
  String? id;
  String? Name;
  String? confDate;
  String? confTime;
  String? confPlace;
  String? confLink;

  //Constructor
  ConferencesItemReport({
    required this.id,
    required this.Name,
    required this.confDate,
    required this.confTime,
    required this.confPlace,
    required this.confLink,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ConfName'] = Name;
    map['ConfDate'] = confDate;
    map['ConfTime'] = confTime;
    map['ConfPlace'] = confPlace;
    map['ConfLink'] = confLink;
    return map;
  }
}
