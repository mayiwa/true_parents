import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_parents/model/otp.dart';
import 'package:true_parents/model/pickup.dart';
import 'package:http/http.dart' as http;
import 'package:true_parents/pages/otp_manager_pages/delete_otp_dialog.dart';
import 'package:true_parents/pages/parent_guardian_manager/delete_approved_pickup_dialog.dart';
import 'package:true_parents/pages/parent_guardian_manager/update_approved_pickup_dialog.dart';

class ViewOTP extends StatefulWidget {
  @override
  _ViewOTPState createState() => _ViewOTPState();
}

class _ViewOTPState extends State<ViewOTP> {

  List<OTP>  otpList = List();
  final String url = "https://www.truehistory.com.ng/Guardians/Flutter/getOTP.php";

  Future<List> getViewOTP() async {

    print("activatiing");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String facialID = preferences.get("subjectID");
    Map body = {"facialID":facialID};

    http.Response response = await http.post(url,body:body);
    List list = jsonDecode(response.body);
    //print(list);

    for(int i = 0; i < list.length; i++){
      otpList.add(OTP.fromMap(list[i]));
    }

    setState(() {
      otpList;
    });

    return list;
  }

  @override
  void initState() {
    super.initState();
    getViewOTP();
  }

  void _refreshState(){
    setState(() {
      print("refresh state done");
      otpList.clear();
      getViewOTP();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildChildListBody()
    );
  }

  Widget _buildChildListBody(){
    return ListView.builder(
        itemCount: otpList.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(20.0),
                  leading: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.orange,
                    child:otpList[index].firstName != null?
                        Text(
                          "${otpList[index].firstName[0].toUpperCase()}${otpList[index].lastName[0].toUpperCase()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0
                          ),
                        )  :null,
                  ),
                  title: Text("${otpList[index].firstName} ${otpList[index].lastName}"),
                  subtitle: Text("OTP: ${otpList[index].subjectID}"),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      splashColor: Colors.orange,
                      onPressed: ()=>showDialog(context: context, builder: (BuildContext context){
                        return DeleteOTPDialog(otpList[index].subjectID,otpList[index].familyID,_refreshState);
                      }),
                      child: Text(
                        "Cancel One Time Password",
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

