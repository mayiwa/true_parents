import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddGuardianDialog extends StatefulWidget {

  final String subjectID,familyID;
  final VoidCallback onRefreshState;

  AddGuardianDialog(this.subjectID, this.familyID, this.onRefreshState);

  @override
  _AddGuardianDialogState createState() => _AddGuardianDialogState();
}

class _AddGuardianDialogState extends State<AddGuardianDialog> {

  String _headerMsg = "";
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
        "Add Guardian Profile",
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: 400.0,
        width: 300.0,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _headerMsg.length > 0 ? Text("$_headerMsg") : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "First Name",
                  ),
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
                  onSaved: (value)=>_mobileNo = value,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0)),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: _addGuardianToServer,
                child: Text(
                  "Add Guardian",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0)),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed:()=> Navigator.pop(context),
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

  _addGuardianToServer() async {

    if(_validateAndSave()){

      String url = "https://www.truehistory.com.ng/Guardians/Flutter/addGuardian.php";
      Map body = {
        "subjectID" : widget.subjectID,
        "familyID" : widget.familyID,
        "firstName" : _firstName,
        "lastName" : _lastName,
        "mobileNo" : _mobileNo
      };

      print(body);

      http.Response response = await http.post(url,body:body);

      if(response != null) {

        print("adding guardian" + response.body);

        if (response.body == "success") {
          setState(() {
            _headerMsg = "Add Successful";
          });
          widget.onRefreshState();
          Navigator.pop(context);
        } else {
          _headerMsg = "Add Failed. Please try again";
        }
      }else{
        _headerMsg = "No response from server";
      }


    }
  }
}