import 'package:firebase_auth/firebase_auth.dart';
import 'package:wup/Pages/SignUp/signup_email.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wup/Pages/Login/login_page.dart';
import 'package:wup/utils/icons/custom_icons.dart';
import 'package:wup/utils/hex_color.dart';
import 'package:wup/utils/constants/api.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/user.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dart:convert' as convert;



class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
//  Country _selected;
  String _phoneNo;
  String smsCode;
  String _verificationID;
  bool _isLoading = false;
  UserDao _userDao;
  User _user;
  String _countryCode = '+91';


  @override
  void initState() {
    super.initState();
    _userDao = UserDao();
    _user = User();
  }

  @override
  void dispose() {
    super.dispose();
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
      phoneNumber: this._phoneNo,
      timeout: const Duration(seconds: 15),
      verificationCompleted: onPhoneVerificationCompleted,
      verificationFailed: onPhoneVerificationFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );

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
              this.smsCode = value;
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
                        builder: (context) => SignUpEmailPage(),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                    AuthCredential _authCredential = PhoneAuthProvider.getCredential(verificationId: this._verificationID, smsCode: this.smsCode);
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

  void _signInWithPhoneNumber(AuthCredential authCredential) async {
    print("Signing in with Creds");
    FirebaseAuth.instance.signInWithCredential(authCredential).then((firebaseUser) {
      print("SignUp Done");
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => SignUpEmailPage(),
        ),
      );
    }).catchError((error) {
      print("Error ${error.toString()}");
    });
  }

  _checkUserExists() async{
    _phoneNo = _countryCode+_phoneNo;
    User user;
    await _userDao.delete(user);
    var apiUrl = DOMAIN+API_VERSION+VERIFY_USER;
    var jsonResponse;

    http.post(apiUrl, body: {'phoneID': '123', 'phonenumber': _phoneNo, 'type': 'PHONE_NUMBER'}).then((response) {
      print(response.body);
      jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse["status"] == 'success' && jsonResponse['user_exists']) {
        _user.phoneNo = _phoneNo;
        _userDao.insert(_user).then((value) {
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        });
        setState(() {
          _isLoading = false;
        });
      }
      else {
        _user.phoneNo = _phoneNo;
        _userDao.insert(_user).then((value) {
          showSMSCodeDialogue(context);
          _verifyPhoneNo();
        });
        setState(() {
          _isLoading = false;
        });
      }
    });
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
              padding: EdgeInsets.all(5),
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: HexColor("#ff5106"),
                  shape: BoxShape.circle
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(CustomIcons.videocam, color: Colors.white, size: 90,),
                  Text("flips", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),)
                ],
              )
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left:10.0),
                child:  CountryCodePicker(
                  onChanged: (CountryCode countryCode){
                    this._countryCode = countryCode.dialCode;
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: _countryCode,
                  favorite: ['+91','IN'],
                  // optional. Shows only country name and flag
                  showCountryOnly: true,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
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
                  maxLength: 12,
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
              elevation: 1.0,
              highlightColor: Colors.blueAccent,
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () async{
                setState(() {
                  _isLoading = true;
                });
                await _checkUserExists();
              },
              child: _isLoading?CircularProgressIndicator(backgroundColor: Colors.white,):Text("Next", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
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
