class VolunteerOpReport {
  //Variables
  String? id;
  String? opName;
  String? opDate;
  String? opTime;
  String? opLocation;
  String? opNumber;
  String? opLink;

  //Constructor
  VolunteerOpReport({
    required this.id,
    required this.opName,
    required this.opDate,
    required this.opTime,
    required this.opLocation,
    required this.opNumber,
    required this.opLink,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['op_name'] = opName;
    map['op_date'] = opDate;
    map['op_time'] = opTime;
    map['op_location'] = opLocation;
    map['op_number'] = opNumber;
    map['op_link'] = opLink;
    return map;
  }
}
