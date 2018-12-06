import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendSickNote extends StatefulWidget {

  final String subjectID;

  SendSickNote(this.subjectID);

  @override
  _SendSickNoteState createState() => _SendSickNoteState();
}

class _SendSickNoteState extends State<SendSickNote> {

  String _noteBody;
  String _selectID;
  String _headerMsg = "";
  bool _hideWidgets = false;
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> _menuList = <DropdownMenuItem<String>>[
    DropdownMenuItem(value:"0",child: Text("Please Pick A School"))
  ];

  @override
  void initState() {
    super.initState();
    _selectID = "0";
    _getDropDownData();
  }

  bool validateAndSave(){

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
      title: Text("Send Sick Note To School"),
      content: !_hideWidgets ? Container(
        height: 500.0,
        width: 350.0,
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _headerMsg.isNotEmpty && _headerMsg.length > 3 ? Text("$_headerMsg"):Container(),
                Padding(padding: EdgeInsets.all(10.0)),
                _buildDropDownButton(),
                Padding(padding: EdgeInsets.all(10.0)),
                TextFormField(
                  maxLines: 5,
                  validator: (value)=>value.isEmpty?"The note can't be empty":null,
                  onSaved: (value)=>_noteBody = value,
                  decoration: InputDecoration(
                      labelText: "Input sick note here"
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                RaisedButton(
                  onPressed: _sendNote,
                  child: Text("Send Note"),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                RaisedButton(
                  onPressed:()=>Navigator.pop(context),
                  child: Text("Cancel Send Note"),
                )
              ],
            )
        ),
      ):Container(
        height: 250.0,
        width: 250.0,
        child: Column(
          children: <Widget>[
            Text("$_headerMsg"),
            Padding(padding: EdgeInsets.all(10.0)),
            RaisedButton(
                onPressed:_resetForm,
                child: Text("Send Another Note"),
            ),
            Padding(padding: EdgeInsets.all(10.0),),
            RaisedButton(
              onPressed: ()=>Navigator.pop(context),
              child: Text("Cancel"),
            )
          ],
        ),
      ),
    );
  }

  _sendNote() async {

      if(validateAndSave()) {

          String url = "https://www.truehistory.com.ng/Guardians/Flutter/sendNote.php";
          Map body = {
            "subjectID":widget.subjectID,
            "noteBody": _noteBody
          };

          http.Response response = await http.post(url, body: body);

          if (response != null) {
            if (response.body == "success") {
              _headerMsg = "Note has been sent to school";
              _hideWidgets = true;
            }
            else
              _headerMsg = "Note was not sent. Please contact support 0802 831 2219";
          } else {
            _headerMsg = "Failed to receive response. Please contact support on 0802 831 2219";
          }

          setState(() {
            _headerMsg;
          });
      }
  }

  void _resetForm() {
    setState(() {
      _hideWidgets = false;
    });
  }

  _getDropDownData() async {

    String url = "https://www.truehistory.com.ng/Guardians/Flutter/getSchoolList.php";
    Map body = {
      "subjectID":widget.subjectID
    };

    http.Response response = await http.post(url,body: body);

    if(response != null){

      List remoteData = jsonDecode(response.body);

      for(int i = 0; i < remoteData.length; i++){

        print(remoteData[i]["id"]);
          _menuList.add(
              DropdownMenuItem<String>(
                  value: remoteData[i]["id"],
                  child: SizedBox(
                    width: 200.0,
                    child: Text("${remoteData[i]["name"]}")
                  ),
              )
          );
      }

      setState(() {
        _menuList;
      });

    }else{
      _headerMsg = "Unable to retrieve list of schools";
    }

  }

  Widget _buildDropDownButton() {

    return DropdownButton(
        value: _selectID,
        items: _menuList,
        onChanged: ((String value){
          setState(() {
            _selectID = value;
          });
        })
    );

  }
}
