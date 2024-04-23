class StudentGroupModel {
  //Variables
  String? id;
  String? name;
  String? date;
  String? time;
  String? location;
  String? numPerson;

  //Constructor
  StudentGroupModel({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.numPerson,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['date'] = date;
    map['time'] = time;
    map['location'] = location;
    map['NumPerson'] = numPerson;
    return map;
  }
}
