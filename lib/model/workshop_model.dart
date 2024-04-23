class WorkshopModel {
  //Variables
  String? id;
  String? name;
  String? presentBy;
  String? date;
  String? time;
  String? location;
  String? workshopLink;
  String? timestamp;

  //Constructor
  WorkshopModel({
    required this.id,
    required this.name,
    required this.presentBy,
    required this.date,
    required this.time,
    required this.location,
    required this.workshopLink,
    required this.timestamp,

  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['WorkshopName'] = name;
    map['PresentBy'] = presentBy;
    map['WorkshopDate'] = date;
    map['WorkshopTime'] = time;
    map['WorkshopPlace'] = location;
    map['WorkshopLink'] = workshopLink;
    map['timestamp']=timestamp;

    return map;
  }
}
