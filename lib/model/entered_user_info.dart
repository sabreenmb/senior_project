class enteredUserInfo {
  //Variables
  String? collage;
  String? major;
  String? intrests;
  String? hobbies;
  String? skills;

  //Constructor
  enteredUserInfo({
    required this.collage,
    required this.major,
    required this.intrests,
    required this.hobbies,
    required this.skills,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['collage'] = collage;
    map['major'] = major;
    map['intrests'] = intrests;
    map['hobbies'] = hobbies;
    map['skills'] = skills;
    return map;
  }
}
