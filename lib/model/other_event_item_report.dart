class OtherEventsItemReport {
  //Variables
  String? id;
  String? Name;
  String? presentBy;
  String? otherEventDate;
  String? otherEventTime;
  String? otherEventPlace;

  //Constructor
  OtherEventsItemReport({
    required this.id,
    required this.Name,
    required this.presentBy,
    required this.otherEventDate,
    required this.otherEventTime,
    required this.otherEventPlace,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OtherEventName'] = Name;
    map['PresentBy'] = presentBy;
    map['OtherEventDate'] = otherEventDate;
    map['OtherEventTime'] = otherEventTime;
    map['OtherEventPlace'] = otherEventPlace;
    return map;
  }
}
