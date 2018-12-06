import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:true_parents/util/manage_parent_info.dart';

class AddOtp extends StatefulWidget {

  @override
  _AddOtpState createState() {
    return _AddOtpState();
  }
}

class _AddOtpState extends State<AddOtp> {

  String _headerMsg = "";
  String _otpMsg = "";
  String _subjectID, _familyID;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  bool _showForm = true;
  final _formKey = GlobalKey<FormState>();

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

    return  Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {

    return _showForm == true ?
    Container(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            _headerMsg.length > 3 ? Text(_headerMsg) : Container(),
            Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                  labelText: "First Name", icon: Icon(Icons.person)),
              validator: (value) =>
              value.isEmpty ? "Please input first name" : null,
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                  labelText: "Last Name", icon: Icon(Icons.person_outline)),
              validator: (value) =>
              value.isEmpty ? "Please input last name" : null,
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            MaterialButton(
                color: Theme.of(context).primaryColor,
                splashColor: Colors.orange,
                onPressed: _addOtpToServer,
                child: Text(
                  "Generate One Time Password",
                  style: TextStyle(color: Colors.white),)
            )
          ],
        ),
      ),
    ): Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(20.0)),
            Text("$_otpMsg"),
            Padding(padding: EdgeInsets.all(10.0)),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              splashColor: Colors.orange,
              onPressed: (){
                setState(() {
                  _showForm = true;
                  _headerMsg = "";
                });
              },
              child: Text(
                  "Generate Another One Time Password",
                  style: TextStyle(
                    color: Colors.white
                  ),
              ),
            ),
          ],
        )
    );
  }

  _addOtpToServer() async {

    if(_validateAndSave()){

      String url = "https://www.truehistory.com.ng/Guardians/Flutter/addOTP.php";
      Map body = {
        "subjectID" : _subjectID,
        "familyID" : _familyID,
        "firstName": _firstNameController.text,
        "lastName" : _lastNameController.text
      };

      print(body);

      http.Response response = await http.post(url,body:body);

      if(response != null) {

        print("adding guardian" + response.body);

        if (response.body == "success") {
          setState(() {
            _headerMsg = "Add Successful";
            _otpMsg = "Your One Time Password Is 8459598669669";
            _showForm = false;
            final form = _formKey.currentState;
            form.reset();
          });
        } else {
          _headerMsg = "Add Failed. Please try again";
        }
      }else{
        _headerMsg = "No response from server";
      }

    }
  }

}