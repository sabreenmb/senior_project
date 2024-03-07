class ClinicReport {
  //Variables
  String? id;
  String? clBranch;
  String? clDepartment;
  String? clDoctor;
  String? clDate;
  String? clStarttime;
  String? clEndtime;

  //Constructor
  ClinicReport({
    required this.id,
    required this.clBranch,
    required this.clDepartment,
    required this.clDoctor,
    required this.clDate,
    required this.clStarttime,
    required this.clEndtime,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cl_branch'] = clBranch;
    map['cl_department'] = clDepartment;
    map['cl_doctor'] = clDoctor;
    map['cl_date'] = clDate;
    map['cl_start_time'] = clStarttime;
    map['cl_end_time'] = clEndtime;
    return map;
  }
}
