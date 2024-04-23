class MessageInfoModel {
  //Variables
  late final String senderID;
  late final String receiverID;
  late final String message;
  late final String time;
  late final String readF;
  // final String hobbies;
  // final String skills;

  //Constructor
  MessageInfoModel({
    required this.senderID,
    required this.receiverID,
    required this.message,
    required this.time,
    required this.readF,
  });

  MessageInfoModel.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'].toString();
    receiverID = json['receiverID'].toString();
    message = json['message'].toString();
    // type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    time = json['time'].toString();
    readF = json['readF'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    return {
      data['senderID']: senderID,
      data["receiverID"]: receiverID,
      data["message"]: message,
      data["time"]: time,
      data["readF"]: readF,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      "receiverID": receiverID,
      "message": message,
      "time": time,
      "readF": readF,
    };
  }
}
