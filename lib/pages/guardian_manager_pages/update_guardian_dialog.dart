import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateGuardianDialog extends StatefulWidget {

  final String subjectID, guardianID;
  final String familyID;
  final String firstName, lastName, mobileNo;
  final VoidCallback onRefreshState;

  UpdateGuardianDialog(this.subjectID, this.familyID, this.guardianID, this.firstName, this.lastName, this.mobileNo, this.onRefreshState);

  @override
  _UpdateGuardianDialogState createState() => _UpdateGuardianDialogState();
}

class _UpdateGuardianDialogState extends State<UpdateGuardianDialog> {

  String _errorMsg = "";
  String _firstName, _lastName, _mobileNo;

  final _formKey = GlobalKey<FormState>();

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

    return AlertDialog(
      title: Text(
        "Update Guardian Profile",
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: 350.0,
        width: 300.0,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _errorMsg.length > 0 ? Text("$_errorMsg") : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "First Name",
                  ),
                  initialValue: widget.firstName,
                  onSaved: (value)=>_firstName = value,
                  validator: (value)=> value.isEmpty ? "Please input a first name " : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                  labelText: "Last Name",
                  ),
                  initialValue: widget.lastName,
                  onSaved: (value)=>_lastName = value,
                  validator: (value)=> value.isEmpty? "Please input a last name ": null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                  ),
                  initialValue: widget.mobileNo,
                  onSaved: (value)=>_mobileNo = value,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0)),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: _updateGuardianToServer,
                child: Text(
                  "Update Guardian",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0)),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: ()=> Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[

      ],
    );
  }

  _updateGuardianToServer() async {

    if(_validateAndSave()){

      String url = "https://www.truehistory.com.ng/Guardians/Flutter/updateGuardian.php";
      Map body = {
        "subjectID" : widget.subjectID,
        "guardianID" : widget.guardianID,
        "familyID" : widget.familyID,
        "firstName" : _firstName,
        "lastName" : _lastName,
        "mobileNo" : _mobileNo
      };

      http.Response response = await http.post(url,body:body);

      if(response != null) {

        print(response.body);

        if (response.body == "success") {
          _errorMsg = "Update Successful";
          widget.onRefreshState();
          Navigator.pop(context);
        } else {
          _errorMsg = "Update Failed. Please try again";
        }
      }else{
        _errorMsg = "No response from server";
      }

      setState(() {
        _errorMsg;
      });

    }
  }
}