import 'package:flutter/material.dart';
import 'package:true_parents/pages/sign_out_dialog.dart';
import 'manage_parent_info.dart';

class BuildDrawer extends StatefulWidget {
  @override
  _BuildDrawerState createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {
  String acctName, acctEmail, imgUrl;

  @override
  void initState() {
    super.initState();
    getProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: acctName != null && acctName.length > 0
                ? Text("$acctName")
                : null,
            accountEmail: acctEmail != null && acctEmail.length > 0
                ? Text("$acctEmail")
                : null,
            currentAccountPicture: imgUrl != null && imgUrl.length > 0
                ? ClipOval(
                    child: Image.network(
                      "$imgUrl",
                      height: 200.0,
                      width: 200.0,
                    ),
                  )
                : null,
          ),
          ListTile(
            trailing: Icon(Icons.notifications_active, color: Colors.green),
            title: Text("Notifications"),
            onTap: () =>
                Navigator.popAndPushNamed(context, "/notificationPage"),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          ListTile(
            trailing: Icon(Icons.person, color: Colors.green),
            title: Text("Profile"),
            onTap: () => Navigator.popAndPushNamed(context, "/profilePage"),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          ListTile(
            trailing: Icon(Icons.child_care, color: Colors.green),
            title: Text("Children"),
            onTap: () => Navigator.popAndPushNamed(context, "/childPage"),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          ListTile(
            trailing: Icon(Icons.security, color: Colors.green),
            title: Text("Guardians"),
            onTap: () => Navigator.popAndPushNamed(context, "/guardianPage"),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          ListTile(
            trailing: Icon(Icons.group_add, color: Colors.green),
            title: Text("Pickups"),
            onTap: () =>
                Navigator.popAndPushNamed(context, "/parentGuardianPage"),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          ListTile(
            trailing: Icon(Icons.group_add, color: Colors.green),
            title: Text("One Time Password Manager"),
            onTap: () => Navigator.popAndPushNamed(context, "/otpPage"),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          ListTile(
            trailing: Icon(Icons.settings, color: Colors.green),
            title: Text("Settings"),
            onTap: () => Navigator.popAndPushNamed(context, "/settingsPage"),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          ListTile(
            trailing: Icon(Icons.directions_run, color: Colors.green),
            title: Text("Sign Out"),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SignOutDialog();
                }),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          ListTile(
            trailing: Icon(Icons.cancel, color: Colors.green),
            title: Text("Close"),
            onTap: () => Navigator.pop(context),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }

  void getProfileInfo() async {
    Map map = await ManageParentInfo.getInfo();
    setState(() {
      acctName = map["firstName"] + " " + map["lastName"];
      acctEmail = map["email"];
      imgUrl = map["fbImageUrl"];
      print(imgUrl);
    });
  }
}
