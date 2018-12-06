import 'package:flutter/material.dart';
import 'package:true_parents/pages/auth.dart';
import 'package:true_parents/pages/guardian_manager.dart';
import 'package:true_parents/pages/home.dart';
import 'package:true_parents/pages/login.dart';
import 'package:true_parents/pages/notifications_manager.dart';
import 'package:true_parents/pages/otp_manager.dart';
import 'package:true_parents/pages/otp_manager_pages/add_otp.dart';
import 'package:true_parents/pages/parent_guardian_manager.dart';
import 'package:true_parents/pages/update_profile.dart';
import 'child_manager.dart';

class RootPage extends StatefulWidget {

  final BaseAuth auth;
  RootPage({this.auth});

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus{
  signedIn,
  notSignedIn
}

class _RootPageState extends State<RootPage> {

  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((userId){
      setState(() {
       _authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    }).catchError((error){

    });
  }

  void _signedIn(){
    setState(() {
     _authStatus = AuthStatus.signedIn;
     print("I am in signed In");
    });
  }

  void _signedOut(){
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
      print("I am in signed Out");
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    if(_authStatus == AuthStatus.signedIn){
      page = OtpManager();
    }else if(_authStatus == AuthStatus.notSignedIn){
      page = LoginPage(
        auth: widget.auth,
        onSignedIn: _signedIn,
      );
    }

    return page;
  }
}
