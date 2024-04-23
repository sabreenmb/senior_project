class PsychGuidanceModel {
  //Variables
  String? id;
  String? proId;
  String? proName;
  String? collage;
  String? proLocation;
  String? proOfficeNumber;
  String? proEmail;
  //Constructor
  PsychGuidanceModel({
    id= '',
    this.proId='',
    this.proName= '',
    this.proLocation= '',
    this.collage= '',
    this.proOfficeNumber= '',
    this.proEmail= '',
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pg_ID']=proId;
    map['pg_name'] = proName;
    map['pg_location'] = proLocation;
    map['pg_collage'] = collage;
    map['pg_number'] = proOfficeNumber;
    map['pg_email'] = proEmail;
    return map;
  }
}
