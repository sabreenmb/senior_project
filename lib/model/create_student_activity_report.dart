class CreateStudentActivityReport {
  //Variables
  String? id;
  String? activityName;
  String? activityDate;
  String? activityTime;
  String? activityPlace;
  String? numOfPerson;

  //Constructor
  CreateStudentActivityReport({
    required this.id,
    required this.activityName,
    required this.activityDate,
    required this.activityTime,
    required this.activityPlace,
    required this.numOfPerson,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ActivityName'] = activityName;
    map['ActivityDate'] = activityDate;
    map['ActivityTime'] = activityTime;
    map['ActivityPlace'] = activityPlace;
    map['NumOfPerson'] = numOfPerson;
    return map;
  }
}
