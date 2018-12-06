import 'package:flutter/material.dart';
import 'package:true_parents/pages/auth.dart';

class HomePage extends StatelessWidget {

  final BaseAuth auth;
  final VoidCallback onSignOut;

  HomePage({this.auth, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  void _signOut() async {
    await auth.signOutUser();
   // _playSound();
    onSignOut();
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: <Widget>[
        FlatButton(
            onPressed: _signOut,
            child: Text(
                "Sign Out",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white
              ),
            )
        ),
      ],
      title: Text(
          "TrueAttendance Parents",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
      ),
    );
  }

  ListView _buildBody() {
    return ListView(
      children: <Widget>[
        Text("Hello")
      ],
    );
  }
}

