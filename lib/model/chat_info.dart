class ChatInfo {
  //Variables
  late final String user1;
  late final String user2;
  late final String lastMsg;
  late final String lastMsgSender;
  late final String readF;

  late final String lastMsgTime;

  //Constructor
  ChatInfo({
    required this.user1,
    required this.user2,
    required this.lastMsg,
    required this.lastMsgSender,
    required this.readF,
    required this.lastMsgTime,
  });

  ChatInfo.fromJson(Map<String, dynamic> json) {
    user1 = json['user1'].toString();
    user2 = json['user2'].toString();
    lastMsg = json['lastMsg'].toString();
    lastMsgSender = json['lastMsgSender'].toString();
    readF = json['readF'].toString();

    lastMsgTime = json['lastMsgTime'].toString();
    // message = json['message'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    return {
      data['user1']: user1,
      data["user2"]: user2,
      data["lastMsg"]: lastMsg,
      data["lastMsgSender"]: lastMsgSender,
      data["readF"]: readF,
      data["lastMsgTime"]: lastMsgTime,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'user1': user1,
      "user2": user2,
      "lastMsg": lastMsg,
      "lastMsgSender": lastMsgSender,
      "readF": readF,
      "lastMsgTime": lastMsgTime,
    };
  }
}
