import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:wup/pages/home.dart';
import 'package:wup/utils/media/media_picker.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/constants/api.dart';
import 'package:wup/utils/database/models/user.dart';
import 'package:wup/utils/constants/media.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:intl/intl.dart';

class SignUpBioPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _SignUpBioPageState();
}

class _SignUpBioPageState extends State<SignUpBioPage> {
  IconData visibilityButton = Icons.visibility_off;
  List<String> genderList = ["Male", "Female", "Other", "Prefer Not to Say"];
  String _selectedGender = "Male";
  TextEditingController _ageFieldController = TextEditingController();
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _usernameFieldController = TextEditingController();
  String apiUrl = DOMAIN+API_VERSION+VERIFY_USER;
  String _userName;
  UserDao _userDao;
  Icon _userNameValidIcon = Icon(Icons.error, color: Colors.red,);
  bool _validUserName = false;
  String _name;
  User _user;
  bool _profileImageSelected = false;
  CircleAvatar _profileImage;
  File _croppedProfileImage;
  String firebaseUserId;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((firebaseUser) async{
      firebaseUser.getIdToken().then((firebaseTokenIdResult) {
        firebaseUserId = firebaseTokenIdResult.token;
      });
    });
    _userDao = UserDao();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  bool _isUserNameValid(String value) {
    _userName = '@'+value;

    var jsonResponse;

    http.post(apiUrl, body: {'phoneid': '123', 'username': _userName, 'type': 'USER_NAME'}).then((response) {
      jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse["status"] == 'success' && jsonResponse['user_exists']) {

        setState(() {
          _validUserName = false;
          _userNameValidIcon = Icon(Icons.error, color: Colors.red,);
        });

      }
      else{
        setState(() {
          _validUserName = true;
          _userNameValidIcon = Icon(Icons.check_circle, color: Colors.green,);
        });

      }
    });

    return _validUserName;
  }

  Future _createUser() async{
    print('Creatying User...');
    _name = _nameFieldController.text;
    Dio dio = new Dio();
    dio.options.baseUrl = DOMAIN;
    var _userValidityStatus = _verifyUserDetails();
    print(_userValidityStatus);
    switch (_userValidityStatus) {
      case 'NAME_NOT_VALID':
        //TODO: Do name not valid stuff
        break;
      case 'USERNAME_NOT_VALID':
        //TODO: Do username not valid stuff
        break;
      case 'AGE_NOT_VALID':
        //TODO: Do age not valid stuff
      case 'VALID_USER':
       _user = await _userDao.getUser();
       _user.name = _name;
       _user.username = _userName;
       _user.gender = _selectedGender;
       _user.dateOfBirth = DateTime.parse(_ageFieldController.text.replaceAll("-", "")).millisecondsSinceEpoch;
       FormData formData = new FormData.from({
         'name': _user.name,
         'username': _user.username,
         'gender': _user.gender,
         'email': _user.email,
         'phonenumber': _user.phoneNo,
         'password': _user.password,
         'dateofbirth': _user.dateOfBirth.toString(),
         'country': "IN",
         'profileimage': new UploadFileInfo(_croppedProfileImage, 'profileimage.jpg'),
       });

       _userDao.update(_user).then((value) async{
         print("Form Data");
         print(formData);
         dio.options.headers = {HttpHeaders.authorizationHeader: 'Bearer $firebaseUserId'};
         var response;
         try {
           response = await dio.post(API_VERSION+USER, data: formData);
         }on DioError catch(err) {
           if(err.response.statusCode == 500) {
             print("Ooops! Something went wrong");
             await FirebaseAuth.instance.signOut();
           }
         }
         print(response);
         if(response.statusCode == 200) {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
         }
       });
    }
  }


  String _verifyUserDetails() {
    if (_name == null) {
      return 'NAME_NOT_VALID';
    }
    else if(!_validUserName) {
      return 'USERNAME_NOT_VALID';
    }

    return 'VALID_USER';
  }

  void _selectProfileImage() async{
    _croppedProfileImage = await Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => MediaPickerPage(mediaType: MediaType.image)
      ),
    );
    setState(() {
      _profileImageSelected = true;
      _profileImage = CircleAvatar(
        backgroundImage: FileImage(_croppedProfileImage),
        radius: 40.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget signUpBioPageContainer = Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.grey)
              ),
              child: IconButton(
                icon: _profileImageSelected?_profileImage:Icon(Icons.account_circle, color: Colors.grey, size: 60,),
                onPressed: () async{
                  _selectProfileImage();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              width: 300.0,
              height: 80,
              child: TextField(
                controller: _nameFieldController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  counterText: '',
                  hintText: "Name",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                style: TextStyle(fontSize: 20),
                maxLength: 10,
                onChanged: (value) {
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              width: 300.0,
              height: 80,
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
                    suffixIcon: _userNameValidIcon,
                    prefix: Text("@"),
                    hintText: "Username",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20)
                ),
                style: TextStyle(fontSize: 20),
                maxLength: 10,
                onChanged: _isUserNameValid
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30.0),
              padding: EdgeInsets.only(left: 20),
              width: 300.0,
              height: 65,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    hint: Text("Gender"),
                    value: _selectedGender,
                    items: genderList.map((gender) {
                      return DropdownMenuItem(
                        child: Text(gender),
                        value: gender,
                      );
                    }).toList(),
                    onChanged: (value) {
                      _selectedGender = value;
                      setState(() {

                      });
                    }
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              width: 300.0,
              height: 60,
              child: TextField(
                controller: _ageFieldController,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    counterText: '',
                    hintText: "Date of Birth",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20)
                ),
                style: TextStyle(fontSize: 20),
                maxLength: 10,
                onTap: () {
                  DatePicker.showDatePicker(context,
                    currentTime: DateTime(1995, 1, 1),
                    showTitleActions: true,
                    minTime: DateTime(1900, 1, 1),
                    maxTime: DateTime.now(), onChanged: (date) {
                    }, onConfirm: (date) {
                      _ageFieldController.text = DateFormat('yyyy-MM-dd').format(date);
                      setState(() {

                      });
                    },
                  );
                },
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
                onPressed: () async{
                  await _createUser();
                },
                child: new Text("Next", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      ),
    );


    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: signUpBioPageContainer
    );
  }
}


