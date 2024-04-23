import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'constant.dart';
import 'interface/LaunchScreen.dart';
import 'theme.dart';

class NetworkConnection extends StatefulWidget {
  const NetworkConnection({super.key});

  @override
  State<NetworkConnection> createState() => _NetworkConnectionState();
}

class _NetworkConnectionState extends State<NetworkConnection> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: CustomColors.backgroundColor,
          body: ModalProgressHUD(
            color: Colors.black,
            opacity: 0.5,
            progressIndicator: loadingFunction(context, false),
            inAsyncCall: isLoading,
            child: AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.fromLTRB(12, 30, 12, 12),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
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
                      style: TextStyles.text1D,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          Future.delayed(const Duration(seconds: 2))
                              .then((_) async {
                            await network();
                            if (isOffline) {
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              isLoading = false;
                              await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LaunchScreen()));
                            }
                          });

                          // Add your logic here
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          backgroundColor: CustomColors.lightBlue,
                          side: BorderSide(
                              color: CustomColors.lightBlue, width: 1),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          'اعادة المحاولة',
                          style: TextStyle(color: CustomColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
