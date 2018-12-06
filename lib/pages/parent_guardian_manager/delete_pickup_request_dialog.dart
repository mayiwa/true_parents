import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeletePickUpRequestDialog extends StatefulWidget {

  final String guardianID;
  final String familyID, startDate, endDate;
  final VoidCallback onCancel;

  DeletePickUpRequestDialog(this.guardianID, this.familyID, this.startDate, this.endDate, this.onCancel);

  @override
  _DeletePickUpRequestDialogState createState() => _DeletePickUpRequestDialogState();
}

class _DeletePickUpRequestDialogState extends State<DeletePickUpRequestDialog> {

  String headerMsg;

  @override
  void initState() {
    super.initState();
    _buildHeaderMsg();
  }

  @override
  Widget build(BuildContext context) {

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

    headerMsg = "Are you sure you wish to decline this pick up request?";

    setState(() {
      headerMsg;
    });

    return headerMsg;

  }

  void _sendFireBaseNotification(){

  }

  _processCmd() async {

    String url = "https://www.truehistory.com.ng/Guardians/Flutter/deletePickUpRequest.php";

    Map body = {

      "familyID":widget.familyID,
      "startDate":widget.startDate,
      "endDate":widget.endDate,
      "guardianID":widget.guardianID
    };
    
    print("Body sent: $body");

    http.Response response = await http.post(url,body: body);

    if(response != null){

      if(response.body == "success"){
        widget.onCancel();
        _sendFireBaseNotification();
        Navigator.pop(context);
      }else{

      }

    }else{
      headerMsg = "No response received from TrueHistory. Please check your internet connection or contact support on 0802 831 2219";
    }

  }
}
