import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/theme.dart';
import 'ServicesScreen.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _enteredID = '';
  String _enteredPass = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    print("inv");

    _formKey.currentState!.save();
    try {
      final userCridential = await _firebase.signInWithEmailAndPassword(
          email: _enteredID, password: _enteredPass);
      print("user:$userCridential");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => ServisesScreen()));
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'Athuntication Faild'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Text("logo"),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'الرقم الجامعي',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.lightBlue, width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.lightBlue, width: 2),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: CustomColors.lightBlue),
                              ),
                            ),
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length != 7) {
                                return "tsxt masage";
                              }
                            },
                            onSaved: (value) {
                              print(_enteredID);

                              _enteredID = ("$value" + "@uj.edu.sa");
                            },
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'الرقم السري',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: CustomColors.lightBlue, width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: CustomColors.lightBlue, width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: CustomColors.lightBlue),
                                  ),),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                print("invalid");

                                return "pa'ss masage";
                              }
                            },
                            textAlign: TextAlign.right,
                            obscureText: true,
                            onSaved: (value) {
                              _enteredPass = value!;
                            },
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(175, 50),
                                backgroundColor: CustomColors.lightBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27))),
                            onPressed: _submit,
                            child: const Text("تسجيل الدخول"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
