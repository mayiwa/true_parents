import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ManageParentInfo{

  static Future<Map<String,String>> getInfo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String,String> map = Map();
    map["subjectID"] = prefs.get("subjectID");
    map["firstName"] = prefs.get("firstName");
    map["lastName"] = prefs.get("lastName");
    map["email"] = prefs.get("email");
    map["mobileNo"] = prefs.get("mobileNo");
    map["familyID"] = prefs.get("familyID");
    map["schoolType"] = prefs.get("schoolType");
    map["schoolIDList"] = prefs.get("schoolIDList");
    map["imgPath"] = prefs.get("imgPath");
    map["fbImageUrl"] = prefs.get("fbImageUrl");
    map["keepSignedIn"] = prefs.get("keepSignedIn");

    print("The map we got: $map");

    return map;

  }

  static Future<bool> setInfo(Map<String,dynamic> map) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("subjectID", map["subjectID"]);
    prefs.setString("firstName", map["firstName"]);
    prefs.setString("lastName", map["lastName"]);
    prefs.setString("email", map["email"]);
    prefs.setString("mobileNo", map["mobileNo"]);
    prefs.setString("familyID", map["familyID"]);
    prefs.setString("schoolType", map["schoolType"]);
    prefs.setString("schoolIDList", map["schoolIDList"]);
    prefs.setString("fbImageUrl", map["fbImageUrl"]);
    prefs.setString("imgPath", map["ImgPath"]);
    prefs.setString("keepSignedIn", map["keepSignedIn"]);

    return true;
  }

}