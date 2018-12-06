import 'package:firebase_database/firebase_database.dart';

class FBNotification {

  String key;
  String deviceID;
  String branchID;
  String messageID;
  String subject;
  String message;
  String clockType;
  String familyID;
  String childID;
  String guardianID;
  String dateTime;
  String schoolClassID;
  String childImgUrl;
  String guardianImgUrl;


  FBNotification({this.deviceID, this.branchID, this.messageID, this.subject,
      this.message, this.clockType, this.familyID, this.childID, this.childImgUrl, this.guardianImgUrl,
      this.guardianID, this.dateTime, this.schoolClassID});


  FBNotification.fromSnapshot(DataSnapshot snapshot){
    key = snapshot.key;
    deviceID = snapshot.value["deviceID"];
    branchID = snapshot.value["branchID"];
    messageID = snapshot.value["messageID"];
    subject = snapshot.value["subject"];
    message = snapshot.value["message"];
    clockType = snapshot.value["clockType"];
    familyID = snapshot.value["familyID"];
    childID = snapshot.value["childID"];
    guardianID = snapshot.value["guardianID"];
    dateTime = snapshot.value["dateTime"];
    schoolClassID = snapshot.value["schoolClassID"];
    childImgUrl = snapshot.value["childImgUrl"];
    guardianImgUrl = snapshot.value["guardianImgUrl"];
  }

  FBNotification.fromMap(this.deviceID, this.branchID, this.messageID, this.subject,
      this.message, this.clockType, this.familyID, this.childID,
      this.guardianID, this.dateTime, this.schoolClassID);

  Map<String,dynamic> toMap(){

        return {
          "deviceID" : deviceID,
          "branchID" : branchID,
          "messageID" : messageID,
          "subject" : subject,
          "message" : message,
          "clockType" : clockType,
          "familyID" : familyID,
          "childID": childID,
          "guardianID": guardianID,
          "dateTime": dateTime,
          "schoolClassID": schoolClassID,
          "childImgUrl":childImgUrl,
          "guardianImgUrl":guardianImgUrl
      };
  }


}