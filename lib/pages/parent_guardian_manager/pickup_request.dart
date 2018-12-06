import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_parents/model/pickup.dart';
import 'package:http/http.dart' as http;
import 'package:true_parents/pages/parent_guardian_manager/delete_pickup_request_dialog.dart';

class PickUpRequest extends StatefulWidget {
  @override
  _PickUpRequestState createState() => _PickUpRequestState();
}

class _PickUpRequestState extends State<PickUpRequest> {

  List<PickUp>  requestList = List();
  final String url = "https://www.truehistory.com.ng/Guardians/Flutter/getPickUpRequests.php";

  Future<List> getPickUpRequests() async {

    print("activating");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String facialID = preferences.get("subjectID");
    Map body = {"facialID":facialID};

    http.Response response = await http.post(url,body:body);
    List list = jsonDecode(response.body);
    //print(list);

    for(int i = 0; i < list.length; i++){
      requestList.add(PickUp.fromMap(list[i]));
    }

    setState(() {
      requestList;
    });

    return list;
  }

  @override
  void initState() {
    super.initState();
    getPickUpRequests();
  }

  void _refreshState(){
    setState(() {
      print("refresh state done");
      requestList.clear();
      getPickUpRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildChildListBody();
  }

  Widget _buildChildListBody(){
    return ListView.builder(
        itemCount: requestList.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(40.0),
                  leading: ClipOval(
                    child: requestList[index].fbImageUrl != null? Image.network(
                      requestList[index].fbImageUrl,
                      fit: BoxFit.cover,
                      width: 120.0,
                      height: 120.0,
                    ):null,
                  ),
                  title: Text("${requestList[index].firstName} ${requestList[index].lastName}"),
                  subtitle: Text("From: ${requestList[index].startDate} To: ${requestList[index].endDate}"),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: ()=>showDialog(context: context, builder: (BuildContext context){
                        return DeletePickUpRequestDialog(requestList[index].subjectID,requestList[index].familyID,
                            requestList[index].startDate,requestList[index].endDate,_refreshState);
                      }),
                      child: Text(
                        "Decline Pickup Request",
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

