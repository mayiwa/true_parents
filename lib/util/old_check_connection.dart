import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class CheckConnection{

  static Future<Map<String,String>> getStatus() async {

    Connectivity _connectivity = new Connectivity();
    StreamSubscription<ConnectivityResult> _connectivitySubscription;
    Map<String, String> statusList = Map();

    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {

//      connectionStatus = (await _connectivity.checkConnectivity()).toString();
//      print("status here: $connectionStatus");

      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result){
        connectionStatus = result.toString();
        print("status here: $connectionStatus");
      });

      if(connectionStatus != ConnectivityResult.none.toString()){

        statusList["network"] = "connected";

        String url = 'http://www.google.com';
        http.Response response;
        try {
          response = await http.post(url);
          if (response.toString().isNotEmpty) {
            statusList["internet"] = "connected";
          }else{
            statusList["internet"] = "no";
          }
          print('msg 1: ' + response.body);
        }catch(e){
          print('msg 2: ' + e.toString());
        }

      }else{
        statusList["network"] = "no";
      }

    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    return statusList;

  }

}