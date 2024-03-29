class CoursesItemReport {
  //Variables
  String? id;
  String? name;
  String? presentBy;
  String? date;
  String? time;
  String? location;
  String? courseLink;

  //Constructor
  CoursesItemReport({
    required this.id,
    required this.name,
    required this.presentBy,
    required this.date,
    required this.time,
    required this.location,
    required this.courseLink,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CourseName'] = name;
    map['PresentBy'] = presentBy;
    map['CourseDate'] = date;
    map['CourseTime'] = time;
    map['CoursePlace'] = location;
    map['CourseLink'] = courseLink;
    return map;
  }
}
