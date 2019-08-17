import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wup/Constants/paths.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:wup/Models/user.dart';
import 'package:wup/Pages/User/Login/login_page.dart';
//import 'package:path/path.dart';
import 'dart:io';


class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Country _selected;
  String _phoneNo;
  String _smsCode;
  String _verificationID;
  static CurrentUserInfo userInfo;


  _WelcomePageState(){
    _selected = Country(asset: 'assets/flags/in_flag.png', dialingCode: '91', isoCode: 'IN', name: 'India');
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _verifyPhoneNo() async{

    this._phoneNo = "+${this._selected.dialingCode} ${this._phoneNo}";
    print("Phone No: ${this._phoneNo}");

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      print("Auto Ret Time");
      this._verificationID = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this._verificationID = verId;
    };

    final PhoneVerificationCompleted onPhoneVerificationCompleted = (AuthCredential authCredential) {
      FirebaseAuth.instance.signInWithCredential(authCredential).then((authResult) {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => LoginPage(userInfo),
          ),
        );
      }).catchError((e) {
        print(e);
        });
    };

    final PhoneVerificationFailed onPhoneVerificationFailed = (AuthException authException) {
      print("${authException.message}");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this._phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: onPhoneVerificationCompleted,
        verificationFailed: onPhoneVerificationFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );

  }

  _checkUserExists() {
    //TODO Check if the user Phone number already exists in the db.
    //If yes
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => LoginPage(userInfo),
      ),
    );


    //If no

//    Navigator.push(context,
//      MaterialPageRoute(
//        builder: (context) => LoginPage(userInfo),
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {

    Widget welcomePageContainer = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom:20.0),
              width: 200.0,
              height: 200.0,
              child: Image.asset(Path.APP_LOGO)
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left:10.0),
                child: CountryPicker(
                  dense: false,
                  showFlag: true,
                  showDialingCode: true,
                  showName: false,
                  onChanged: (Country country) {
                    setState(() {
                      _selected = country;
                    });
                  },
                  selectedCountry: _selected,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: 200.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      counterText: '',
                      hintText: "Phone number",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20)),
                  style: TextStyle(fontSize: 20),
                  maxLength: 10,
                  onChanged: (value) {
                    this._phoneNo = value;
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 40.0),
            width: 300.0,
            height: 90.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              padding: const EdgeInsets.all(8.0),
              elevation: 5.0,
              highlightColor: Colors.blueAccent,
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: _checkUserExists,
              child: new Text("Next", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );



    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: welcomePageContainer
      )
    );
  }
}
