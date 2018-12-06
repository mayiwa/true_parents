import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_parents/model/pickup.dart';
import 'package:http/http.dart' as http;
import 'package:true_parents/pages/parent_guardian_manager/delete_approved_pickup_dialog.dart';
import 'package:true_parents/pages/parent_guardian_manager/update_approved_pickup_dialog.dart';

class ApprovedPickUp extends StatefulWidget {
  @override
  _ApprovedPickUpState createState() => _ApprovedPickUpState();
}

class _ApprovedPickUpState extends State<ApprovedPickUp> {

  List<PickUp>  approvedList = List();
  final String url = "https://www.truehistory.com.ng/Guardians/Flutter/getApprovedPickUps.php";

  Future<List> getApprovedPickUps() async {

    print("activatiing");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String facialID = preferences.get("subjectID");
    Map body = {"facialID":facialID};

    http.Response response = await http.post(url,body:body);
    List list = jsonDecode(response.body);
    //print(list);

    for(int i = 0; i < list.length; i++){
      approvedList.add(PickUp.fromMap(list[i]));
    }

    setState(() {
      approvedList;
    });

    return list;
  }

  @override
  void initState() {
    super.initState();
    getApprovedPickUps();
  }

  void _refreshState(){
    setState(() {
      print("refresh state done");
      approvedList.clear();
      getApprovedPickUps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildChildListBody();
  }

  Widget _buildChildListBody(){
    return ListView.builder(
        itemCount: approvedList.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(40.0),
                  leading: ClipOval(
                    child: approvedList[index].fbImageUrl != null? Image.network(
                      approvedList[index].fbImageUrl,
                      fit: BoxFit.cover,
                      width: 120.0,
                      height: 120.0,
                    ):null,
                  ),
                  title: Text("${approvedList[index].firstName} ${approvedList[index].lastName}"),
                  subtitle: Text("From: ${approvedList[index].startDate} To: ${approvedList[index].endDate}"),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed:()=>showDialog(context: context, builder: (BuildContext context){
                        return UpdateApprovedPickUpDialog(approvedList[index].subjectID, approvedList[index].familyID,
                            approvedList[index].firstName,approvedList[index].lastName,
                            approvedList[index].startDate,approvedList[index].endDate);
                      }),
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: ()=>showDialog(context: context, builder: (BuildContext context){
                        return DeleteApprovedPickUpDialog(approvedList[index].subjectID,approvedList[index].familyID,
                          approvedList[index].startDate,approvedList[index].endDate,_refreshState);
                      }),
                      child: Text(
                        "Cancel Pickup",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
    );
  }
}

