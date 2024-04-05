class CoursesItemReport {
  //Variables
  String? id;
  String? name;
  String? presentBy;
  String? date;
  String? time;
  String? location;
  String? courseLink;
  String? timestamp;


  //Constructor
  CoursesItemReport({
    required this.id,
    required this.name,
    required this.presentBy,
    required this.date,
    required this.time,
    required this.location,
    required this.courseLink,
    required this.timestamp,

  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CourseName'] = name;
    map['PresentBy'] = presentBy;
    map['CourseDate'] = date;
    map['CourseTime'] = time;
    map['CoursePlace'] = location;
    map['CourseLink'] = courseLink;
    map['timestamp']=timestamp;

    return map;
  }
}
