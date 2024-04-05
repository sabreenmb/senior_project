class OtherEventsItemReport {
  //Variables
  String? id;
  String? name;
  String? presentBy;
  String? date;
  String? time;
  String? location;
  String? otherEventLink;
  String? timestamp;


  //Constructor
  OtherEventsItemReport({
    required this.id,
    required this.name,
    required this.presentBy,
    required this.date,
    required this.time,
    required this.location,
    required this.otherEventLink,
    required this.timestamp,

  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OtherEventName'] = name;
    map['PresentBy'] = presentBy;
    map['OtherEventDate'] = date;
    map['OtherEventTime'] = time;
    map['OtherEventPlace'] = location;
    map['OtherEventLink'] = otherEventLink;
    map['timestamp']=timestamp;

    return map;
  }
}
