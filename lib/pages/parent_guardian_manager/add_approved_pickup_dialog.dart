import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:true_parents/util/date_time_util.dart';

class AddApprovedPickUpDialog extends StatefulWidget {

  final String subjectID,familyID,firstName,lastName;

  AddApprovedPickUpDialog(this.subjectID, this.familyID,this.firstName,this.lastName);

  @override
  _AddApprovedPickUpDialogState createState() {
    return _AddApprovedPickUpDialogState();
  }
}

class _AddApprovedPickUpDialogState extends State<AddApprovedPickUpDialog> {

  String _headerMsg = "";
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

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

  Future<Null> _selectDate(BuildContext context, String type) async {

    if(type == "fromDate"){

      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _fromDate,
          firstDate: DateTime(DateTime.now().year),
          lastDate: DateTime.now().add(Duration(days: 90))
      );

      if(picked != null && picked != _fromDate){
        print("Date Picked: ${picked.toString()}");
        setState(() {
          _fromDate = picked;
        });
      }
    }else if(type == "toDate"){

      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _toDate,
          firstDate: DateTime(DateTime.now().year),
          lastDate: DateTime.now().add(Duration(days: 90))
      );

      if(picked != null && picked != _toDate){
        print("Date Picked: ${picked.toString()}");
        setState(() {
          _toDate = picked;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(
        "Click On The Dates Below To Select Time Period Parent Can Pick Up Your Kids",
        textAlign: TextAlign.justify,
      ),
      content: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child:
            Form(
              key: _formKey,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  _headerMsg.length > 3 ? Text(_headerMsg):Container(),
                  Padding(padding: EdgeInsets.all(10.0)),
                  Text("Parent: ${widget.firstName} ${widget.lastName}"),
                  Padding(padding: EdgeInsets.all(10.0)),
                  Row(
                    children: <Widget>[
                      InkWell(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.date_range),
                            Padding(padding: EdgeInsets.only(left: 5.0),),
                            Text("From: ${MyDateTime.extractDateOnly(_fromDate.toString())}")
                          ],
                        ),
                        onTap: (){
                          _selectDate(context,"fromDate");
                        } ,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  Row(
                    children: <Widget>[
                      InkWell(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.date_range),
                            Padding(padding: EdgeInsets.only(left: 5.0),),
                            Text("To: ${MyDateTime.extractDateOnly(_toDate.toString())}")
                          ],
                        ),
                        onTap: (){
                          _selectDate(context,"toDate");
                        } ,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  RaisedButton(
                    color: Colors.green,
                    onPressed: _addGuardianToServer,
                    child: Text(
                      "Make Temporary Guardian",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _addGuardianToServer() async {

    if(_validateAndSave()){

      String url = "https://www.truehistory.com.ng/Guardians/Flutter/addParentGuardian.php";
      Map body = {
        "subjectID" : widget.subjectID,
        "familyID" : widget.familyID,
        "fromDate" : _fromDate.toString(),
        "toDate" : _toDate.toString()
      };

      print(body);

      http.Response response = await http.post(url,body:body);

      if(response != null) {

        print("adding guardian" + response.body);

        if (response.body == "success") {
          setState(() {
            _headerMsg = "Add Successful";
          });
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