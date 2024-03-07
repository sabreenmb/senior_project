import 'package:flutter/material.dart';

class MyDateUtil {
  // for getting formatted time from milliSecondsSinceEpochs String
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // for getting formatted time for sent & read
  static String getMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
        ? '$formattedTime - ${sent.day} ${_getMonth(sent)}'
        : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  //get last message time (used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
        : '${sent.day} ${_getMonth(sent)}';
  }

  //get formatted last active time of user in chat screen
  // static String getLastActiveTime(
  //     {required BuildContext context, required String lastActive}) {
  //   final int i = int.tryParse(lastActive) ?? -1;

  //   //if time is not available then return below statement
  //   if (i == -1) return 'Last seen not available';

  //   DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
  //   DateTime now = DateTime.now();

  //   String formattedTime = TimeOfDay.fromDateTime(time).format(context);
  //   if (time.day == now.day &&
  //       time.month == now.month &&
  //       time.year == time.year) {
  //     return 'Last seen today at $formattedTime';
  //   }

  //   if ((now.difference(time).inHours / 24).round() == 1) {
  //     return 'Last seen yesterday at $formattedTime';
  //   }

  //   String month = _getMonth(time);

  //   return 'Last seen on ${time.day} $month on $formattedTime';
  // }

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'يناير';
      case 2:
        return 'فبراير';
      case 3:
        return 'مارس';
      case 4:
        return 'ابريل';
      case 5:
        return 'مايو';
      case 6:
        return 'يونيو';
      case 7:
        return 'يوليو';
      case 8:
        return 'اغسطس';
      case 9:
        return 'سبتمبر';
      case 10:
        return 'اكتوبر';
      case 11:
        return 'نوفمبر';
      case 12:
        return 'ديسمبر';
    }
    return 'NA';
  }
}
