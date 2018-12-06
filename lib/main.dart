import 'package:flutter/material.dart';
import 'package:true_parents/pages/auth.dart';
import 'package:true_parents/pages/otp_manager.dart';
import 'pages/login.dart';
import 'pages/root.dart';
import 'pages/notifications_manager.dart';
import 'pages/parent_guardian_manager.dart';
import 'pages/update_profile.dart';
import 'pages/child_manager.dart';
import 'pages/guardian_manager.dart';

void main(){

  Widget _defaultHome = LoginPage(auth: Auth());

  if(_checkAuthenticated())
    _defaultHome = RootPage(auth: Auth(),);

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome To TrueParents",
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: {
          "/":(BuildContext context)=> RootPage(auth: Auth()),
          "/loginPage":(BuildContext context)=> LoginPage(auth: Auth()),
          "/notificationPage":(BuildContext context)=> NotificationsManager(),
          "/childPage":(BuildContext context)=> ChildManager(),
          "/guardianPage":(BuildContext context)=> GuardianManager(),
          "/parentGuardianPage":(BuildContext context)=> ParentGuardianManager(),
          "/otpPage":(BuildContext context)=> OtpManager(),
          "/profilePage":(BuildContext context)=> UpdateProfile()
        },
  ));
}

bool _checkAuthenticated() {
  return true;
}