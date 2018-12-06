import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<Map<String,dynamic>> signInWithEmailAndPassword(String url, String email, String password);
  Future<Map<String,dynamic>> signInWithCustomToken(String url, String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> getCurrentUser();
  Future<void> signOutUser();
}

class Auth extends BaseAuth {

  Future<Map<String,dynamic>> signInWithEmailAndPassword(String url,String email, String password) async {
    var body = {
      "u":email,
      "p":password
    };
    http.Response response = await http.post(url, body: body);
    Map<String,dynamic> map = jsonDecode(response.body);
    return map;
  }

  Future<Map<String,dynamic>> signInWithCustomToken(String url,String email, String password) async {
    var body = {"u":email, "p":password};
    http.Response response = await http.post(url, body: body);
    Map<String,dynamic> map = jsonDecode(response.body);

    String token = map["token"];
    print("Token received: $token");
    FirebaseUser user = await FirebaseAuth.instance.signInWithCustomToken(token: token).catchError((error){
      print("Error from Login: $error");
    });

    if(user != null)
       map["uid"] = user.uid;
    else
      map["error"] = "Unable signInWithToken";

    return map;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {

    FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password);

    return user.uid;
  }

  Future<String> getCurrentUser() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser().catchError((error){
      print("Error from getCurrentUser: $error");
    });

    return user.uid;
  }

  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

}