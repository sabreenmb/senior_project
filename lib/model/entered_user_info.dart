class enteredUserInfo {
  //Variables
  late String image_url;
  late String userID;
  late String rule;
  late String name;
  late String collage;
  late String major;
  late String intrests;
  late String hobbies;
  late String skills;
  late String pushToken;

  //Constructor
  enteredUserInfo({
    required this.image_url,
    required this.userID,
    required this.rule,
    required this.name,
    required this.collage,
    required this.major,
    required this.intrests,
    required this.hobbies,
    required this.skills,
    required this.pushToken,
  });

  enteredUserInfo.fromJson(Map<String, dynamic> json) {
    userID = json['userID'] ?? '';
    rule = json['userID'] ?? '';
    name = json['userID'] ?? '';
    collage = json['userID'] ?? '';
    major = json['userID'] ?? '';
    intrests = json['userID'] ?? '';
    hobbies = json['userID'] ?? '';
    skills = json['userID'] ?? '';

    pushToken = json['pushToken'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_url'] = image_url;
    map['intrests'] = intrests;
    map['hobbies'] = hobbies;
    map['skills'] = skills;

    map['pushToken'] = pushToken;
    return map;
  }
}
