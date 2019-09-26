import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/Pages/SignUp/signup_bio.dart';
import 'package:wup/Utils/Icons/custom_icons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class SignUpEmailPage extends StatefulWidget {
  

  @override
  State<StatefulWidget> createState() => _SignUpEmailPageState();
}

class _SignUpEmailPageState extends State<SignUpEmailPage> {
  bool _obscureText = true;
  IconData visibilityButton = Icons.visibility_off;
  UserDao _userDao;
  TextEditingController _emailTextController;
  TextEditingController _passwordTextController;
  String _email;
  String _password;
  FacebookLogin _facebookLogin;
  
  
  @override
  void initState() {

    _userDao = UserDao();
    _facebookLogin = FacebookLogin();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();

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

  void _updateUserData() {
    _userDao.getUser().then((user) {
      this._email = _emailTextController.text;
      this._password = _passwordTextController.text;

      user.email = _email;
      user.password = _password;

      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: this._email, password: this._password
      ).then((authResult) {
        _userDao.update(user).then((value) {
          FirebaseAuth.instance.signInWithEmailAndPassword(email: this._email, password: this._password).then((authResult){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => SignUpBioPage(),
              ),
            );
          });
        });
      });
    });
  }

  void _signUpFacebook() {
    _facebookLogin.logInWithReadPermissions(['email']).then((result) {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
          FirebaseAuth.instance.signInWithCredential(credential).then((authResult) {
            _userDao.getUser().then((user) {
              user.email = authResult.user.email;
              _userDao.update(user).then((value) {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => SignUpBioPage(),
                  ),
                );
              });
            });
          });
          break;

        case FacebookLoginStatus.cancelledByUser:
          print("error");
          break;

        case FacebookLoginStatus.error:
          print("Login failed");
          break;
      }
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget signUpEmailPageContainer = Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              width: 300.0,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailTextController,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    counterText: '',
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20)
                ),
                style: TextStyle(fontSize: 20),
                onChanged: (value) {
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              width: 300.0,
              child: TextField(
                controller: _passwordTextController,
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
                    hintText: "New Password",
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
                  _updateUserData();
                },
                child: new Text("Next", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
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
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(icon: Icon(CustomIcons.facebook_circled, size: 70, color: Colors.blueAccent,), onPressed: (){
                _signUpFacebook();
              }),
            ),
          ],
        ),
      ),
    );



    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: signUpEmailPageContainer
    );
  }
}


