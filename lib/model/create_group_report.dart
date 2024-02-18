class CreateGroupReport {
  //Variables
  String? id;
  String? subject;
  String? subjectCode;
  String? sessionDate;
  String? sessionPlace;
  String? numPerson;

  //Constructor
  CreateGroupReport({
    required this.id,
    required this.subject,
    required this.subjectCode,
    required this.sessionDate,
    required this.sessionPlace,
    required this.numPerson,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Subject'] = subject;
    map['SubjectCode'] = subjectCode;
    map['SessionDate'] = sessionDate;
    map['SessionPlace'] = sessionPlace;
    map['NumPerson'] = numPerson;
    return map;
  }
}
