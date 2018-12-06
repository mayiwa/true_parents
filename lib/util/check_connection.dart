import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:true_parents/util/check_internet_connection.dart';

class CheckConnection extends StatefulWidget {

  final String pageName;

  CheckConnection(this.pageName);

  @override
  _CheckConnectionState createState(){
    return  _CheckConnectionState();
  }
}

class _CheckConnectionState extends State<CheckConnection> {

  var _connectionStatus = 'Unknown';
  var _internetConnectionStatus = 'Unknown';
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      print(result);
      _connectionStatus = result.toString();

      if(_connectionStatus != ConnectivityResult.none.toString()){
        CheckInternetConnection.getStatus().then((String value){
          _internetConnectionStatus = value;
          if(value.isNotEmpty){
            Timer timer = new Timer(new Duration(seconds: 5), () {
              setState(() {
                _internetConnectionStatus = value;
                print(value);
              });
            });
          }
        });
      }
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
