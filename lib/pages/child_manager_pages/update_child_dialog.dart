import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateChildDialog extends StatefulWidget {

  final String subjectID;
  final String firstName, lastName;
  final VoidCallback onRefreshState;

  UpdateChildDialog(this.subjectID, this.firstName, this.lastName, this.onRefreshState);

  @override
  _UpdateChildDialogState createState() => _UpdateChildDialogState();
}

class _UpdateChildDialogState extends State<UpdateChildDialog> {

  String errorMsg = "";
  String _firstName, _lastName;

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
        "Update Child Profile",
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: 280.0,
        width: 300.0,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              errorMsg.length > 0 ? Text("$errorMsg") : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.firstName,
                  onSaved: (value)=>_firstName = value,
                  validator: (value)=> value.isEmpty ? "Please input a first name " : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.lastName,
                  onSaved: (value)=>_lastName = value,
                  validator: (value)=> value.isEmpty? "Please input a last name ": null,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0)),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: _updateChildToServer,
                child: Text(
                  "Update Child",
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

  _updateChildToServer() async {

    if(_validateAndSave()){

      String url = "https://www.truehistory.com.ng/Guardians/Flutter/updateChild.php";
      Map body = {
        "firstName" : _firstName,
        "lastName" : _lastName
      };

      http.Response response = await http.post(url,body:body);

      if(response != null) {

        print(response.body);

        if (response.body == "success") {
          errorMsg = "Update Successful";
          widget.onRefreshState();
          Navigator.pop(context);
        } else {
          errorMsg = "Update Failed. Please try again";
        }
      }else{
        errorMsg = "No response from server";
      }

      setState(() {
        errorMsg;
      });

    }
  }
}