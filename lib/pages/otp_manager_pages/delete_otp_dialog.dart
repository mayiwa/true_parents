import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteOTPDialog extends StatefulWidget {

  final String subjectID;
  final String familyID;
  final VoidCallback onCancel;

  DeleteOTPDialog(this.subjectID, this.familyID, this.onCancel);

  @override
  _DeleteOTPDialogState createState() => _DeleteOTPDialogState();
}

class _DeleteOTPDialogState extends State<DeleteOTPDialog> {

  String headerMsg;

  @override
  void initState() {
    super.initState();
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
              splashColor: Colors.orange,
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
            splashColor: Colors.orange,
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

    headerMsg = "Are you sure you wish to cancel this One Time Password?";

    setState(() {
      headerMsg;
    });

    return headerMsg;

  }

  void _sendFireBaseNotification(){

  }

  _processCmd() async {

    String url = "https://www.truehistory.com.ng/Guardians/Flutter/deleteOTP.php";

    Map body = {

      "familyID":widget.familyID,
      "guardianID":widget.subjectID
    };
    
    print("Body sent: $body");

    http.Response response = await http.post(url,body: body);

    print(response.body);

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
