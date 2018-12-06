import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DisableDeleteGuardian extends StatefulWidget {

  final String guardianID;
  final String functionType;

  DisableDeleteGuardian(this.guardianID, this.functionType);

  @override
  _DisableDeleteGuardianState createState() => _DisableDeleteGuardianState();
}

class _DisableDeleteGuardianState extends State<DisableDeleteGuardian> {

  String _subjectID;
  String headerMsg;

  @override
  void initState() {
    super.initState();
    _getSubjectID();
  }

  @override
  Widget build(BuildContext context) {

    _buildHeaderMsg();

    return AlertDialog(
      title: Text("$headerMsg"),
      contentPadding: EdgeInsets.all(20.0),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: _processCmd,
              child: Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.white
                  ),
              ),
          ),
          Padding(padding: EdgeInsets.only(left: 5.0,right: 5.0),),
          RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: ()=>Navigator.pop(context),
              child: Text(
                  "No",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
          )
        ],
      ),
    );
  }

  String _buildHeaderMsg() {

    if(widget.functionType == "Delete"){
      headerMsg = "Are you sure you wish to delete this Guardian?";
    }else if(widget.functionType == "Disable"){
      headerMsg = "Are you sure you wish to disable this Guardian?";
    }

    setState(() {
      headerMsg;
    });

    return headerMsg;

  }

  _processCmd() async {

    String url = "https://www.truehistory.com.ng/Guardians/Flutter/deleteGuardian.php";

    Map body = {
      "subjectID":_subjectID,
      "guardianID":widget.guardianID,
      "functionType": widget.functionType
    };

    http.Response response = await http.post(url,body: body);

    if(response != null){

      if(response.body == "success"){

      }else{

      }

    }else{
      headerMsg = "No response received from TrueHistory. Please check your internet connection or contact support on 0802 831 2219";
    }

  }

  void _getSubjectID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _subjectID = prefs.get("subjectID");
    });
  }
}
