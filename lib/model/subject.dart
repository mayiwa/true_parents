import 'package:firebase_database/firebase_database.dart';

class Subject {
  String key;
  String fbUID;
  String subjectID;
  String firstName;
  String lastName;
  String email;
  String mobileNo;
  String fbImageUrl;
  String fbTemplateUrl;
  String imgPath;
  String familyIDList;
  String childIDList;
  String guardianIDList;
  String schoolIDList;
  String schoolType;
  String dateCreated;
  String lastUpdatedAt;

  Subject({this.key,this.fbUID, this.subjectID, this.firstName, this.lastName, this.email,
            this.mobileNo, this.fbImageUrl, this.fbTemplateUrl, this.imgPath, this.familyIDList,
            this.childIDList, this.guardianIDList, this.schoolIDList, this.schoolType,
            this.dateCreated, this.lastUpdatedAt});

  Subject.fromSnapshot(DataSnapshot snapshot){
    key = snapshot.key;
    subjectID = snapshot.value["subjectID"];
    firstName = snapshot.value["firstName"];
    lastName = snapshot.value["lastName"];
    fbImageUrl = snapshot.value["FBImageUrl"];
    fbTemplateUrl = snapshot.value["FbTemplateUrl"];
    imgPath = snapshot.value["ImgPath"];
    familyIDList = snapshot.value["familyIDList"];
    childIDList = snapshot.value["childIDList"];
    guardianIDList = snapshot.value["guardianIDList"];
    schoolIDList = snapshot.value["schoolIDList"];
    schoolType = snapshot.value["schoolType"];
    dateCreated = snapshot.value["dateCreated"];
    lastUpdatedAt = snapshot.value["lastUpdatedAt"];
  }

  Subject.fromMap(Map<String,dynamic> map){
    subjectID = map["subjectID"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    mobileNo = map["mobileNo"];
    email = map["email"];
    fbImageUrl = map["FBImageUrl"];
    fbTemplateUrl = map["FbTemplateUrl"];
    imgPath = map["ImgPath"];
    familyIDList = map["familyIDList"];
    childIDList = map["childIDList"];
    guardianIDList = map["guardianIDList"];
    schoolIDList = map["schoolIDList"];
    schoolType = map["schoolType"];
    dateCreated = map["dateCreated"];
    lastUpdatedAt = map["lastUpdatedAt"];
  }

 toJson(){

      return {
         "subjectID" : subjectID,
         "firstName" : firstName,
         "lastName" : lastName,
         "mobileNo" : mobileNo,
         "email" : email,
         "fbImageUrl" : fbImageUrl,
         "fbTemplateUrl" : fbTemplateUrl,
         "imgPath" : imgPath,
         "familyIDList" : familyIDList,
         "childIDList" : childIDList,
         "guardianIDList" : guardianIDList,
         "schoolIDList" : schoolIDList,
         "schoolType" : schoolType,
         "dateCreated" : dateCreated,
         "lastUpdatedAt" : lastUpdatedAt
      };
  }
}