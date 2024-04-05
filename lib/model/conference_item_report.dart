class ConferencesItemReport {
  //Variables
  String? id;
  String? name;
  String? date;
  String? timestamp;
  String? time;
  String? location;
  String? confLink;

  //Constructor
  ConferencesItemReport({
    required this.id,
    required this.name,
    required this.date,
    required this.timestamp,
    required this.time,
    required this.location,
    required this.confLink,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ConfName'] = name;
    map['ConfDate'] = date;
    map['timestamp']=timestamp;
    map['ConfTime'] = time;
    map['ConfPlace'] = location;
    map['ConfLink'] = confLink;
    return map;
  }
}
