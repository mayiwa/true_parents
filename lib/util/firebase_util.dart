import 'package:firebase_database/firebase_database.dart';

class FireBaseUtil {

  FirebaseDatabase firebaseDatabase;

  FireBaseUtil(this.firebaseDatabase){
    if(firebaseDatabase == null){
       firebaseDatabase = FirebaseDatabase.instance;
    }
  }


}