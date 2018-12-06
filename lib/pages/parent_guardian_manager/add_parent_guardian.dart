import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:true_parents/model/subject.dart';
import 'package:http/http.dart' as http;
import 'package:true_parents/pages/parent_guardian_manager/add_approved_pickup_dialog.dart';
import 'package:true_parents/util/manage_parent_info.dart';
import 'package:true_parents/util/utils.dart' as Util;

class AddParentGuardian extends StatefulWidget {
  @override
  _AddParentGuardianState createState() => _AddParentGuardianState();
}

class _AddParentGuardianState extends State<AddParentGuardian> {

  List<Subject>  subjectList = List();
  String _subjectID, _familyID, _mobileNo, _headerMsg;
  Subject subject;
  bool _formVisibility = true;
  final _formKey = GlobalKey<FormState>();
  final String url = "https://www.truehistory.com.ng/Guardians/Flutter/getParentGuardian.php";

  @override
  void initState() {
    super.initState();
    ManageParentInfo.getInfo().then((map){
      setState(() {
        _subjectID = map["subjectID"];
        _familyID = map["familyID"];
      });
    });
  }

  _validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody(){
    return Center(
      child: _buildSearchForm(),
    );
  }

  Widget _buildSearchForm() {

    if(_formVisibility){

      return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10.0)),
              Center(child: Text(
                "Phone No Of Parent You Wish To Request Pick Up From",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                ),
              )
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              _headerMsg != null ? Text("$_headerMsg") : Container(),
              Padding(padding: EdgeInsets.all(10.0)),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (value)=>_mobileNo = value,
                validator: (value)=> value.isEmpty ? "Please input phone no" : null,
                decoration: InputDecoration(
                    labelText: "Phone No"
                ),
              ),
              Padding(padding: EdgeInsets.all(20.0)),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: _getParent,
                child: Text(
                    "Get Parent",
                    style: TextStyle(
                      color: Colors.white
                    ),
                ),
              ),
              //Padding(padding: EdgeInsets.all(20.0)),
              //subject != null ? _buildParentGuardian() : Container(),
            ],
          )
      );
    }else{
      return ListView(
        children: <Widget>[
          _buildParentGuardian()
        ],
      );
    }
  }

  Widget _buildParentGuardian(){

    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(40.0),
            leading: ClipOval(
              child: subject.fbImageUrl != null ? Image.network(
                subject.fbImageUrl,
                fit: BoxFit.cover,
                width: 120.0,
                height: 120.0,
              ): null,
            ),
            title: Text(subject.subjectID),
            subtitle: Text(subject.firstName + " " + subject.lastName),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: ()=>showDialog(context: context, builder: (BuildContext context){
                    return AddApprovedPickUpDialog(subject.subjectID, _familyID,subject.firstName,subject.lastName);
                  }),
                  child: Text(
                    "Make Temporary Guardian",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: ()=>_switchFormVisibility("visible"),
                  child: Text(
                    "Back To Search",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _switchFormVisibility(String visibility){

    if(visibility == "invisible") {
      setState(() {
        _formVisibility = false;

      });
    }
    else if(visibility == "visible") {
      setState(() {
        _formVisibility = true;
      });
    }

  }

  void _getParent() async {

    if(_validateAndSave()) {

      String url = Util.PARENT_GUARDIAN_URL;
      Map body = {
        "subjectID": _subjectID,
        "mobileNo": _mobileNo
      };

      http.Response response = await http.post(url, body: body);
      if (response != null) {
        setState(() {
          _formVisibility = false;
          subject = Subject.fromMap(jsonDecode(response.body));
        });
      } else {
        setState(() {
          _headerMsg = Util.NoConnectionError;
        });
      }
    }

  }
}

