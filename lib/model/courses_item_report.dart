class CoursesItemReport {
  //Variables
  String? id;
  String? Name;
  String? presentBy;
  String? courseDate;
  String? courseTime;
  String? coursePlace;

  //Constructor
  CoursesItemReport({
    required this.id,
    required this.Name,
    required this.presentBy,
    required this.courseDate,
    required this.courseTime,
    required this.coursePlace,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CourseName'] = Name;
    map['PresentBy'] = presentBy;
    map['CourseDate'] = courseDate;
    map['CourseTime'] = courseTime;
    map['CoursePlace'] = coursePlace;
    return map;
  }
}
