import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Connection{
  static const String projectDatabase= 'senior-project-72daf-default-rtdb.firebaseio.com';
  //todo change name
  static DocumentReference<Map<String, dynamic>> Users(){
    return FirebaseFirestore
        .instance
        .collection("userProfile")
        .doc(FirebaseAuth.instance.currentUser!.email!.split("@")[0]);
  }

  static Uri url(String path){
    return Uri.https(
        projectDatabase ,path+'.json');
  }
  static  Stream<DatabaseEvent> databaseReference(String path){
    return  FirebaseDatabase.instance.reference().child(path).onValue;

  }



}