class MyDateTime {

  static extractDateOnly(String dateTime){
    List<String> info = dateTime.split(" ");
    return info[0];
  }

  static extractTimeOnly(String dateTime){
    List<String> info = dateTime.split(" ");
    List<String> newInfo = info[1].split(".");
    return newInfo[0];
  }

  static Map putDateTimeInArray(String dateTime) {
    String date = extractDateOnly(dateTime);
    String time = extractTimeOnly(dateTime);

    List<dynamic> dateList = date.split("-");
    List<dynamic> timeList = time.split(":");

    print("Date List: $dateList");
    print("Time List: $timeList");

    return {
      "year":int.parse(dateList[0]),
      "month":int.parse(dateList[1]),
      "day":int.parse(dateList[2]),
      "hour":int.parse(timeList[0]),
      "min":int.parse(timeList[1]),
      "sec":int.parse(timeList[2])
    };
  }

}