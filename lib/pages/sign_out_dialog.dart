import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:true_parents/pages/auth.dart';

class SignOutDialog extends StatefulWidget {

  SignOutDialog();

  @override
  _SignOutDialogState createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {

  String headerMsg;
  final Auth auth = Auth();

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
              onPressed: _signOut,
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
    headerMsg = "Are you sure you wish to sign out?";
    setState(() {
      headerMsg;
    });
    return headerMsg;
  }

  void _signOut() async {
    await auth.signOutUser();
    //Navigator.pushNamed(context, "/");
    Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route){ return false;});
  }
}
