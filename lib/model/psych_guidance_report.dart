class PsychGuidanceReport {
  //Variables
  String? id;
  String? name;
  String? collage;
  String? location;
  String? number;
  String? email;

  //Constructor
  PsychGuidanceReport({
    required this.id,
    required this.name,
    required this.collage,
    required this.location,
    required this.number,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pg_name'] = name;
    map['pg_location'] = location;
    map['pg_collage'] = collage;
    map['pg_number'] = number;
    map['pg_email'] = email;
    return map;
  }
}
