import 'package:flutter/material.dart';
import 'package:true_parents/pages/child_manager.dart';
import 'package:true_parents/pages/guardian_manager.dart';
import 'package:true_parents/pages/parent_guardian_manager/add_parent_guardian.dart';
import 'package:true_parents/pages/parent_guardian_manager/approved_pickup.dart';
import 'package:true_parents/pages/parent_guardian_manager/pickup_request.dart';
import 'package:true_parents/pages/update_profile.dart';
import 'package:true_parents/util/build_drawer.dart';
import 'package:true_parents/util/manage_parent_info.dart';
import 'package:true_parents/util/utils.dart' as Util;

class ParentGuardianManager extends StatefulWidget {
  @override
  _ParentGuardianManagerState createState() => _ParentGuardianManagerState();
}

class _ParentGuardianManagerState extends State<ParentGuardianManager> with SingleTickerProviderStateMixin {

  TabController tabController;

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
        title: Text("Manage Pick-Ups With Other Parents"),
        bottom: TabBar(
            controller: tabController,
            tabs: <Tab>[
              Tab(
                icon: Icon(Icons.person_add),
                text: "Add Pickup",
              ),
              Tab(
                icon: Icon(Icons.list),
                text: "Approved Pickups",
              ),
              Tab(
                icon: Icon(Icons.person_add),
                text: "Pickup Requests",
              ),
            ]
        ),
      ),
      body: TabBarView(
          controller: tabController,
          children: <Widget>[
            AddParentGuardian(),
            ApprovedPickUp(),
            PickUpRequest()
          ]
      ),
    );
  }
}

