class CreateGroupReport {
  //Variables
  String? id;
  String? subjectCode;
  String? sessionDate;
  String? sessionTime;
  String? sessionPlace;
  String? numPerson;

  //Constructor
  CreateGroupReport({
    required this.id,
    required this.subjectCode,
    required this.sessionDate,
    required this.sessionTime,
    required this.sessionPlace,
    required this.numPerson,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SubjectCode'] = subjectCode;
    map['SessionDate'] = sessionDate;
    map['SessionTime'] = sessionTime;
    map['SessionPlace'] = sessionPlace;
    map['NumPerson'] = numPerson;
    return map;
  }
}
