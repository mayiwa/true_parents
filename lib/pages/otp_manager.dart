import 'package:flutter/material.dart';
import 'package:true_parents/pages/auth.dart';
import 'package:true_parents/pages/otp_manager_pages/view_otp.dart';
import 'package:true_parents/util/build_drawer.dart';
import 'otp_manager_pages/add_otp.dart';

class OtpManager extends StatefulWidget {
  @override
  _OtpManagerState createState() => _OtpManagerState();
}

class _OtpManagerState extends State<OtpManager> with SingleTickerProviderStateMixin {

  TabController tabController;
  Auth auth = Auth();

  @override
  void initState() {
    super.initState();
    tabController = new TabController(
        length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BuildDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Manage One Time Passwords"),
        bottom: TabBar(
            controller: tabController,
            tabs: <Tab>[
              Tab(
                icon: Icon(Icons.person_add),
                text: "Add OTP",
              ),
              Tab(
                icon: Icon(Icons.list),
                text: "Approved OTPs",
              ),
            ]
        ),
      ),
      body: TabBarView(
          controller: tabController,
          children: <Widget>[
            AddOtp(),
            ViewOTP()
          ]
      ),
    );
  }
}

