import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAPI{
  static const String projectDatabase= 'senior-project-72daf-default-rtdb.firebaseio.com';
  //todo change name
  static DocumentReference<Map<String, dynamic>> currentUserInfo(){
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

  static Reference fireStorageRef( String path,String uniqueFileName){
    return FirebaseStorage.instance
        .ref()
        .child(path)
        .child('$uniqueFileName.jpg');
  }





}