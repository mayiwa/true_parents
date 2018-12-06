import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_parents/model/subject.dart';
import 'package:http/http.dart' as http;
import 'package:true_parents/pages/guardian_manager_pages/add_guardian_dialog.dart';
import 'package:true_parents/pages/guardian_manager_pages/disable_delete_guardian.dart';
import 'package:true_parents/util/build_drawer.dart';
import 'package:true_parents/util/manage_parent_info.dart';
import 'guardian_manager_pages/update_guardian_dialog.dart';

class GuardianManager extends StatefulWidget {
  @override
  _GuardianManagerState createState() => _GuardianManagerState();
}

class _GuardianManagerState extends State<GuardianManager> {

  List<Subject>  subjectList = List();
  String _subjectID, _familyID;
  final String url = "https://www.truehistory.com.ng/Guardians/Flutter/getGuardians.php";

  Future<List> getGuardians() async {

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
    getGuardians();
    ManageParentInfo.getInfo().then((map){
      setState(() {
        _subjectID = map["subjectID"];
        _familyID = map["familyID"];
      });
    });
  }

  void _refreshState(){
    setState(() {
      print("refresh state done");
      subjectList.clear();
      getGuardians();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BuildDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Manage Guardians"),
      ),
      body: _buildGuardianListBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>showDialog(
            context: context,
            builder: (BuildContext context){
          return AddGuardianDialog(_subjectID,_familyID,_refreshState);
        }
        ),
        child: new Icon(Icons.add),
        tooltip: 'Add New Guardian',
      ),
    );
  }

  Widget _buildGuardianListBody(){
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
                        return UpdateGuardianDialog(_subjectID,_familyID,subjectList[index].subjectID,
                            subjectList[index].firstName,
                            subjectList[index].lastName,
                            subjectList[index].mobileNo,_refreshState);
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
                        return DisableDeleteGuardian(subjectList[index].subjectID,"Disable");
                      }),
                      child: Text(
                        "Disable",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: ()=>showDialog(context: context, builder: (BuildContext context){
                        return DisableDeleteGuardian(subjectList[index].subjectID,"Delete");
                      }),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
    );
  }
}

