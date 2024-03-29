class VolunteerOpReport {
  //Variables
  String? id;
  String? name;
  String? date;
  String? time;
  String? location;
  String? opNumber;
  String? opLink;

  //Constructor
  VolunteerOpReport({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.opNumber,
    required this.opLink,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['op_name'] = name;
    map['op_date'] = date;
    map['op_time'] = time;
    map['op_location'] = location;
    map['op_number'] = opNumber;
    map['op_link'] = opLink;
    return map;
  }
}
