import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../interface/LaunchScreen.dart';
import '../theme.dart';
  // const netWedget({super.key});

  void showNetWidgetDialog(BuildContext context) {

    showDialog(
  context: context,
  builder: (BuildContext context)
    {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.fromLTRB(12, 30, 12, 12),
        insetPadding:
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        content: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.close,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'حدث خطأ أثناء الاتصال بالإنترنت',
                  style: TextStyles.heading1D,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'يرجى التحقق من الاتصال بالإنترنت ثم معاودة المحاولة',
                textAlign: TextAlign.center,
                style: TextStyles.text2,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();

// Add your logic here
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 40),
                    backgroundColor: CustomColors.lightBlue,
                    side: BorderSide(color: CustomColors.lightBlue, width: 1),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'حسناً',
                    style: TextStyle(color: CustomColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );}
    );
  }