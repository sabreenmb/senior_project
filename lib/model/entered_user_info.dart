class enteredUserInfo {
  //Variables
  String? rule;
  String? name;
  String? collage;
  String? major;
  String? intrests;
  String? hobbies;
  String? skills;

  //Constructor
  enteredUserInfo({
    this.rule,
    this.name,
    this.collage,
    this.major,
    required this.intrests,
    required this.hobbies,
    required this.skills,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['intrests'] = intrests;
    map['hobbies'] = hobbies;
    map['skills'] = skills;
    return map;
  }
}
