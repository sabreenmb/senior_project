class CreateStudentActivityReport {
  //Variables
  String? id;
  String? name;
  String? date;
  String? time;
  String? location;
  String? numOfPerson;

  //Constructor
  CreateStudentActivityReport({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.numOfPerson,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['date'] = date;
    map['time'] = time;
    map['location'] = location;
    map['NumOfPerson'] = numOfPerson;
    return map;
  }
}
