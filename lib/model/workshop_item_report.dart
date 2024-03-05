class WorkshopsItemReport {
  //Variables
  String? id;
  String? Name;
  String? presentBy;
  String? workshopDate;
  String? workshopTime;
  String? workshopPlace;
  String? workshopLink;

  //Constructor
  WorkshopsItemReport({
    required this.id,
    required this.Name,
    required this.presentBy,
    required this.workshopDate,
    required this.workshopTime,
    required this.workshopPlace,
    required this.workshopLink,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['WorkshopName'] = Name;
    map['PresentBy'] = presentBy;
    map['WorkshopDate'] = workshopDate;
    map['WorkshopTime'] = workshopTime;
    map['WorkshopPlace'] = workshopPlace;
    map['WorkshopLink'] = workshopLink;
    return map;
  }
}
