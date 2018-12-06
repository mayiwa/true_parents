import 'dart:async';
import 'package:flutter/material.dart';
import 'package:true_parents/pages/auth.dart';
import 'package:true_parents/util/manage_parent_info.dart';
import 'package:true_parents/util/check_internet_connection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:true_parents/util/utils.dart' as Util;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final String url = "https://www.truehistory.com.ng/Guardians/Flutter/parentLogin.php";

  LoginPage({this.auth, this.onSignedIn});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _isChecked = false;
  bool _showErrorMsg = false;
  bool _saving = false;
  FormType _formType = FormType.login;
  var _connectionStatus = 'Unknown';
  var _internetConnectionStatus = 'Unknown';
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      print(result);
      _connectionStatus = result.toString();

      if(_connectionStatus != ConnectivityResult.none.toString()){
        CheckInternetConnection.getStatus().then((String value){
          _internetConnectionStatus = value;
          if(value.isNotEmpty){
            Timer timer = new Timer(new Duration(seconds: 5), () {
              setState(() {
                _internetConnectionStatus = value;
                print(value);
              });
            });
          }
        });
      }
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ModalProgressHUD(child: _buildBody(), inAsyncCall: _saving),
    );
  }

  _onKeepSignedIn(bool value){
    setState(() {
      _isChecked = value;
    });
  }

  _validateAndSave() {

    final form = _formKey.currentState;

    if(form.validate()){
       form.save();
       setState(() {
         _saving = true;
       });
       return true;
    }else{
      return false;
    }
  }

  void _submitLogin() async {

    Map<String,dynamic> map;

    if(_validateAndSave()){

      try {

        if(_formType == FormType.login) {

          map = await widget.auth.signInWithCustomToken(widget.url,_email,_password);
          setState(() {
            _saving = false;
          });

          print("info from server: $map");

          map.remove("uid");
          setPreferences(map);
          print("User SubjectID: ${map["subjectID"]}");
          if(map != null && map["subjectID"] != null && map["subjectID"].length > 3){
            print("submit login function called");
            widget.onSignedIn();
          }else{
            print("failed to authenticate user $_email");
            setState(() {
              _showErrorMsg = true;
            });
          }
       }
      }catch(e){
        print("Error: $e");
      }
    }
  }

  void _goToLogin() {
    setState(() {
      _formType = FormType.login;
    });
  }

  AppBar _buildAppBar() {

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
          "Login To TrueAttendance",
          style: TextStyle(
            fontSize: 20.0
          ),
      ),
    );
  }

  Widget _buildBody() {

    List<Widget> _header;

    if(_connectionStatus != ConnectivityResult.none.toString()){

      print("We are here 1");

      String _connectType = "";

      if(_connectionStatus == ConnectivityResult.mobile.toString()) {
        _connectType = 'Mobile connection detected';
      } else if(_connectionStatus == ConnectivityResult.wifi.toString()) {
        _connectType = 'Wifi connection detected';
      }

      if(_internetConnectionStatus == 'noInternet'){
        _header = [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                 " $_connectType but unable to connect to the internet. Please check your data and try again",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.deepOrange
                ),
              )
          )
        ];

      }else{
        _header = [Container()];
      }

    }else{

      print("We are here 2");

      _header = [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "No Mobile or Wifi connection detected. Please check your settings and try again",
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.deepOrange
            ),
          )
      )
      ];
    }

    List<Widget> _errorMsg;

    if(_showErrorMsg) {
      _errorMsg = [
        Text(
             Util.INCORRECT_LOGIN_DETAILS,
             style: TextStyle(
               color: Colors.red,
               fontSize: 15.0,
               fontStyle: FontStyle.italic
             ),
        )
      ];
    }else{
      _errorMsg = [Container()];
    }

    return Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20.0),
              children: _errorMsg + _header + _buildFormFields() + _buildSubmitButtons(),
            )
        )
    );
  }

  List<Widget> _buildFormFields(){
    return [
      TextFormField(
      onSaved: (value) => _email = value,
      validator: (value)=>value.isEmpty ? "Email address can't be empty" : null,
      decoration: InputDecoration(
          icon: Icon(Icons.person),
          labelText: "Please Input email address"
      ),
      style: TextStyle(
          color: Colors.black,
          fontSize: 20.0
      ),
    ),
      Padding(padding: EdgeInsets.all(10.0)),
    TextFormField(
      onSaved: (value)=>_password = value,
      validator: (value){
        if(value.isEmpty){
          return "Password can't be empty";
        }else{
          return null;
        }
      },
      decoration: InputDecoration(
          icon: Icon(Icons.vpn_key),
          labelText: "Please Input Password"
      ),
      style: TextStyle(
          color: Colors.black,
          fontSize: 20.0
      ),
    ),
    ];
  }

  List<Widget> _buildSubmitButtons(){

    if(_formType == FormType.login) {
      return [
        Padding(padding: EdgeInsets.all(20.0)),
        MaterialButton(
          color: Theme.of(context).primaryColor,
          splashColor: Colors.orange,
          onPressed: _submitLogin,
          child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white
              ),
          ),
        ),
      ];
    }else{

      return [
        Padding(padding: EdgeInsets.all(20.0)),
        MaterialButton(
          color: Theme.of(context).primaryColor,
          splashColor: Colors.orange,
          onPressed: _submitLogin,
          child: Text("Create An Account"),
        ),
        FlatButton(
            onPressed: _goToLogin,
            child: Text("Already Have An Account? Click Here To Login")
        )
      ];

    }
  }

  Future<void> setPreferences(Map<String,dynamic> map) async {
    ManageParentInfo.setInfo(map);
  }

}
