class PsychGuidanceReport {
  //Variables
  String? id;
  String? ProName;
  String? collage;
  String? ProLocation;
  String? ProOfficeNumber;
  String? ProEmail;
  //Constructor
  PsychGuidanceReport({
    id= '',
    //model name : firebase name
    this.ProName= '',
    this.ProLocation= '',
    this.collage= '',
    this.ProOfficeNumber= '',
    this.ProEmail= '',
  });


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pg_name'] = ProName;
    map['pg_location'] = ProLocation;
    map['pg_collage'] = collage;
    map['pg_number'] = ProOfficeNumber;
    map['pg_email'] = ProEmail;
    return map;
  }
}
