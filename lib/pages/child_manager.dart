import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_parents/model/subject.dart';
import 'package:http/http.dart' as http;
import 'package:true_parents/pages/child_manager_pages/send_sick_note.dart';
import 'package:true_parents/util/build_bottom_bar.dart';
import 'package:true_parents/util/build_drawer.dart';
import 'child_manager_pages/update_child_dialog.dart';

class ChildManager extends StatefulWidget {
  @override
  _ChildManagerState createState() => _ChildManagerState();
}

class _ChildManagerState extends State<ChildManager> {

  List<Subject>  subjectList = List();
  final String url = "https://www.truehistory.com.ng/Guardians/Flutter/getChildren.php";

  Future<List> getChildren() async {

    print("activatiing");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String facialID = preferences.get("subjectID");
    Map body = {"facialID":facialID};

    http.Response response = await http.post(url,body:body);
    List list = jsonDecode(response.body);
    //print(list);

    for(int i = 0; i < list.length; i++){
      subjectList.add(Subject.fromMap(list[i]));
    }

    setState(() {
      subjectList;
    });

    return list;
  }

  @override
  void initState() {
    super.initState();
    getChildren();
  }

  void _refreshState(){
    setState(() {
      print("refresh state done");
      subjectList.clear();
      getChildren();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: BuildDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Manage Children"),
        ),
        body: _buildChildListBody()
    );
  }

  Widget _buildChildListBody(){
    return ListView.builder(
        itemCount: subjectList.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(40.0),
                  leading: ClipOval(
                    child: subjectList[index].fbImageUrl != null? Image.network(
                      subjectList[index].fbImageUrl,
                      fit: BoxFit.cover,
                      width: 120.0,
                      height: 120.0,
                    ):null,
                  ),
                  title: Text(subjectList[index].subjectID),
                  subtitle: Text(subjectList[index].firstName + " " + subjectList[index].lastName),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed:()=>showDialog(context: context, builder: (BuildContext context){
                        return UpdateChildDialog(subjectList[index].subjectID,
                            subjectList[index].firstName,
                            subjectList[index].lastName,_refreshState);
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
                        return SendSickNote(subjectList[index].subjectID);
                      }),
                      child: Text(
                        "Send Sick Note",
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

