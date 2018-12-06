import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

class CheckInternetConnection{

  static Future<String> getStatus() async {

      String url = 'https://www.truehistory.com.ng';
      http.Response response;

      try {
        response = await http.get(url);
        if (response.statusCode == HttpStatus.ok) {
          return 'yesInternet';
        } else {
          return 'noInternet';
        }
      }catch(e){
        print(e.toString());
        return 'noInternet';
      }
  }

}