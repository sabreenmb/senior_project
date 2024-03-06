class OtherEventsItemReport {
  //Variables
  String? id;
  String? Name;
  String? presentBy;
  String? otherEventDate;
  String? otherEventTime;
  String? otherEventPlace;
  String? otherEventLink;

  //Constructor
  OtherEventsItemReport({
    required this.id,
    required this.Name,
    required this.presentBy,
    required this.otherEventDate,
    required this.otherEventTime,
    required this.otherEventPlace,
    required this.otherEventLink,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OtherEventName'] = Name;
    map['PresentBy'] = presentBy;
    map['OtherEventDate'] = otherEventDate;
    map['OtherEventTime'] = otherEventTime;
    map['OtherEventPlace'] = otherEventPlace;
    map['OtherEventLink'] = otherEventLink;

    return map;
  }
}
