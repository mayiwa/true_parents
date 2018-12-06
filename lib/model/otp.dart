
class OTP {
  String key;
  String subjectID;
  String firstName;
  String lastName;
  String familyID;
  String schoolType;
  String dateCreated;
  String lastUpdatedAt;

  OTP({this.key,this.subjectID, this.firstName, this.lastName,
       this.familyID,this.schoolType,this.dateCreated, this.lastUpdatedAt});

  OTP.fromMap(Map<String,dynamic> map){
    subjectID = map["subjectID"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    familyID = map["familyID"];
    schoolType = map["schoolType"];
    dateCreated = map["dateCreated"];
    lastUpdatedAt = map["lastUpdatedAt"];
  }

 toJson(){

      return {
         "subjectID" : subjectID,
         "firstName" : firstName,
         "lastName" : lastName,
         "familyID" : familyID,
         "schoolType" : schoolType,
         "dateCreated" : dateCreated,
         "lastUpdatedAt" : lastUpdatedAt
      };
  }
}