import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:true_parents/model/subject.dart';
import 'package:http/http.dart' as http;
import 'package:true_parents/util/build_drawer.dart';
import 'package:true_parents/util/manage_parent_info.dart';
import 'package:true_parents/util/utils.dart' as Util;

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  List<Subject>  subjectList = List();
  String _subjectID, _headerMsg;
  Subject subject = Subject();
  final _formKey = GlobalKey<FormState>();
  final String url = Util.GET_PROFILE_URL;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getParentInfo();
  }

  _getParentInfo() async {
    Map<String,String> map = await ManageParentInfo.getInfo();
    print("here mappy mappy: $map");
    setState(() {
      _subjectID = map["subjectID"];
      subject = Subject.fromMap(map);
      _firstNameController.text = subject.firstName;
      _lastNameController.text = subject.lastName;
      _mobileNoController.text = subject.mobileNo;
      _emailController.text = subject.email;
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
    return Scaffold(
      drawer: BuildDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Update Your Profile"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Center(
      child: _buildForm(),
    );
  }

  Widget _buildForm() {

    return Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10.0)),
            _headerMsg != null ? Text("$_headerMsg") : Container(),
            Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: _firstNameController,
              validator: (value)=> value.isEmpty ? Util.INPUT_FIRST_NAME_ERROR_MSG : null,
              decoration: InputDecoration(
                  labelText: "First Name",
                  icon: Icon(Icons.person)
              ),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: _lastNameController,
              validator: (value)=> value.isEmpty ? Util.INPUT_LAST_NAME_ERROR_MSG : null,
              decoration: InputDecoration(
                  labelText: "Last Name",
                  icon: Icon(Icons.person)
              ),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _mobileNoController,
              validator: (value)=> value.isEmpty ? Util.INPUT_PHONE_NO_ERROR_MSG : null,
              decoration: InputDecoration(
                  icon: Icon(Icons.phone_android),
                  labelText: "Phone No"
              ),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value)=> value.isEmpty ? Util.INPUT_EMAIL_ERROR_MSG : null,
              decoration: InputDecoration(
                  labelText: "Email",
                  icon: Icon(Icons.email)
              ),
            ),
            Padding(padding: EdgeInsets.all(20.0)),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: _updateProfile,
                child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Colors.white
                    ),
                ),
            ),
          ],
        )
    );
  }

  void _updateProfile() async {

    if(_validateAndSave()) {

      String url = Util.PARENT_GUARDIAN_URL;

      Map body = {
        "subjectID": _subjectID,
        "firstName": _firstNameController.text,
        "lastName":_lastNameController.text,
        "email":_emailController.text,
        "mobileNo": _mobileNoController.text
      };

      print("send to server: $body");

      http.Response response = await http.post(url, body: body);

      if(response != null) {
          setState(() {
          _headerMsg = "Update Successful";
          ManageParentInfo.setInfo(jsonDecode(response.body));
        });
      } else {
        setState(() {
          _headerMsg = Util.NoConnectionError;
        });
      }
    }

  }
}

