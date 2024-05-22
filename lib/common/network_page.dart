import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../view/login_screen.dart';
import 'common_functions.dart';
import 'constant.dart';
import '../view/launch_screen.dart';
import 'theme.dart';

class NetworkConnection extends StatefulWidget {
  const NetworkConnection({super.key});
  @override
  State<NetworkConnection> createState() => _NetworkConnectionState();
}

class _NetworkConnectionState extends State<NetworkConnection> {
  late StreamSubscription connSub;
  void checkConnectivity(List<ConnectivityResult> result) {
    switch (result[0]) {
      case ConnectivityResult.mobile || ConnectivityResult.wifi:
        if (isOffline != false) {
          setState(() {
            isOffline = false;
          });
        }
        break;
      case ConnectivityResult.none:
        if (isOffline != true) {
          setState(() {
            isOffline = true;
          });
        }
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    connSub = Connectivity().onConnectivityChanged.listen(checkConnectivity);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: CustomColors.backgroundColor,
          body: ModalProgressHUD(
            color: CustomColors.black,
            opacity: 0.5,
            progressIndicator: loadingFunction(context, false),
            inAsyncCall: isLoading,
            child: AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(12, 30, 12, 12),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: CustomColors.red, width: 2),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          size: 50,
                          color: CustomColors.red,
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
                          Future.delayed(const Duration(seconds: 1))
                              .then((_) async {
                            await checkNetworkConnectivity();
                            if (isOffline) {
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              isLoading = false;
                              if (!context.mounted) {
                                return;
                              }
                              if (user != null) {
                                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                                            const LaunchScreen()));
                              } else {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                                            const LoginScreen()));
                              }
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          backgroundColor: CustomColors.lightBlue,
                          side: const BorderSide(
                              color: CustomColors.lightBlue, width: 1),
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text(
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
