import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:wup/Models/user.dart';
import 'package:wup/Pages/User/home.dart';


class LoginPage extends StatefulWidget {
  CurrentUserInfo userInfo;

  LoginPage(CurrentUserInfo userInfo) {
    this.userInfo = userInfo;
  }

  @override
  State<StatefulWidget> createState() => _LoginPageState(userInfo);
}

class _LoginPageState extends State<LoginPage> {
  CurrentUserInfo userInfo;
  bool _obscureText = true;
  IconData visibilityButton = Icons.visibility_off;
  String _phoneNo;


  _LoginPageState(CurrentUserInfo userInfo) {
    this.userInfo = userInfo;
  }

  @override
  void initState() {
    super.initState();
  }

  void _toggle() {
    setState(() {
      print(_obscureText);
      if (_obscureText) {
        _obscureText = false;
        visibilityButton = Icons.visibility;
      }
      else {
        visibilityButton = Icons.visibility_off;
        _obscureText = true;
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    Widget loginPageContainer = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            width: 300.0,
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  counterText: '',
                  hintText: "Phone number or Email",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 20)
              ),
              style: TextStyle(fontSize: 20),
              maxLength: 10,
              onChanged: (value) {
                _phoneNo = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: 300.0,
            child: TextField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  suffixIcon: IconButton(icon: Icon(visibilityButton, color: Colors.blue,),
                      onPressed: _toggle),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 20)
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 40.0),
            width: 300.0,
            height: 90.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              padding: const EdgeInsets.all(8.0),
              elevation: 1.0,
              highlightColor: Colors.blueAccent,
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: new Text("Login", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );



    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: loginPageContainer
    );
  }
}


