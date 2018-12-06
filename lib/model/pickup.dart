
class PickUp {

  String subjectID;
  String firstName;
  String lastName;
  String mobileNo;
  String startDate;
  String endDate;
  String fbImageUrl;
  String imgPath;
  String familyID;
  String dateCreated;
  String lastUpdatedAt;

  PickUp({this.subjectID, this.firstName, this.lastName, this.startDate,this.mobileNo,
            this.endDate, this.fbImageUrl, this.imgPath, this.familyID,
            this.dateCreated, this.lastUpdatedAt});

  PickUp.fromMap(Map<String,dynamic> map){
    subjectID = map["subjectID"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    mobileNo = map["mobileNo"];
    //print("Start Date received: " + map["startDate"]);
    startDate = map["startDate"];
    endDate = map["endDate"];
    fbImageUrl = map["FBImageUrl"];
    imgPath = map["ImgPath"];
    familyID = map["familyID"];
    dateCreated = map["dateCreated"];
    lastUpdatedAt = map["lastUpdatedAt"];
  }

 toJson(){

      return {
         "subjectID" : subjectID,
         "firstName" : firstName,
         "lastName" : lastName,
         "mobileNo" : mobileNo,
         "fbImageUrl" : fbImageUrl,
         "imgPath" : imgPath,
         "familyID" : familyID,
         "dateCreated" : dateCreated,
         "lastUpdatedAt" : lastUpdatedAt
      };
  }
}