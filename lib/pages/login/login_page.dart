import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wup/pages/home.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'dart:io';

import 'package:wup/utils/database/models/user.dart';
import 'package:wup/utils/http/users/verify.dart';


class LoginPage extends StatefulWidget {



  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  IconData visibilityButton = Icons.visibility_off;
  TextEditingController _usernameFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();
  User _user;
  String _smsCode;
  String _verificationID;
  UserDao _userDao = UserDao();
  VerifyUser _verifyUser = VerifyUser();

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

  Future showSMSCodeDialogue(BuildContext buildContext) {
    return showDialog(
        context: buildContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter SMS Code"),
            contentPadding: const EdgeInsets.all(10.0),
            content: TextField(
              onChanged: (value) {
                this._smsCode = value;
              },
            ),
            actions: <Widget>[
              FlatButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    FirebaseAuth.instance.currentUser().then((user) async{
                      if(user != null) {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                        AuthCredential _authCredential = PhoneAuthProvider.getCredential(verificationId: this._verificationID, smsCode: this._smsCode);
                        _signInWithPhoneNumber(_authCredential);
                      }
                    });
                  },
                  child: Text("Verify")
              )
            ],
          );
        }
    );
  }

  Future<void> _verifyPhoneNo() async{
    _user = await _userDao.getUser();

    print(_user.toMap());
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this._verificationID = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      print("SMS Code sent.");
      this._verificationID = verId;
      setState(() {
//        _smsCodeSent = true;
      });
    };
    final PhoneVerificationCompleted onPhoneVerificationCompleted = (AuthCredential authCredential) {
      print('Auto Verification Success');
      _signInWithPhoneNumber(authCredential);
    };

    final PhoneVerificationFailed onPhoneVerificationFailed = (AuthException authException) {
      print("${authException.message}");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _user.phoneNo,
      timeout: const Duration(seconds: 15),
      verificationCompleted: onPhoneVerificationCompleted,
      verificationFailed: onPhoneVerificationFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );

  }

  void _signInWithPhoneNumber(AuthCredential authCredential) async {
    print("Signing in with Creds");
    FirebaseAuth.instance.signInWithCredential(authCredential).then((firebaseUser) {
      print("SignUp Done");
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }).catchError((error) {
      print("Error ${error.toString()}");
    });
  }

  void _signInUserWithEmail() async{
    var username = _usernameFieldController.text;
    var password = _passwordFieldController.text;
    _user = await _userDao.getUser();
    _user.username = '@'+username;
    await _userDao.update(_user);
    var response = await _verifyUser.verifyUser('LOGIN_VERIFICATION');
    if(response.statusCode == 200) {
      print(response.data );
      var email = response.data['email'];
      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((authResult) {
        print("Signin Successful");
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      });

    }else {
      print(response.data());
    }
  }


  @override
  Widget build(BuildContext context) {

    Widget loginPageContainer = Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              width: 300.0,
              child: TextField(
                controller: _usernameFieldController,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    counterText: '',
                    prefixText: '@',
                    hintText: "Username",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20)
                ),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              width: 300.0,
              child: TextField(
                obscureText: _obscureText,
                controller: _passwordFieldController,
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
                onPressed: _signInUserWithEmail,
                child: new Text("Login", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 40.0),
                height: 100.0,
                width: 300,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Divider(
                        height: 50,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                        ),
                        child: Center(
                          child: Text("OR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        ),
                      ),
                    )
                  ],
                )
            ),
            Container(
//              padding: EdgeInsets.only(top: 40.0),
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: IconButton(icon: Icon(Icons.phone, size: 30, color: Colors.white,), onPressed: (){
                showSMSCodeDialogue(context);
                _verifyPhoneNo();
              }),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text("Login via phone", style: TextStyle(fontWeight: FontWeight.bold, ),),
            )
          ],
        ),
      ),
    );



    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: loginPageContainer
    );
  }
}


