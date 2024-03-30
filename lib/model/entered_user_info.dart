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
  late Map<String, dynamic> offersPreferences;

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
    required this.offersPreferences,
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
    // offersPreferences = json['offersPreferences'] ?? '';
    if (json['offersPreferences'] != null &&
        json['offersPreferences'] is Map<String, dynamic>) {
      offersPreferences = json['offersPreferences'] as Map<String, dynamic>;
    } else {
      offersPreferences = {};
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_url'] = image_url;
    map['intrests'] = intrests;
    map['hobbies'] = hobbies;
    map['skills'] = skills;
    map['pushToken'] = pushToken;
    map['offersPreferences'] = offersPreferences;
    return map;
  }
}