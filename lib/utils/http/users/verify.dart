import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as prefix0;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:wup/utils/constants/api.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/user.dart';

class VerifyUser {
  final Function progressHandler;

  Dio dio = new Dio();
  User _user;
  UserDao _userDao = UserDao();


  VerifyUser({this.progressHandler}) {
    dio.options.baseUrl = DOMAIN;

  }

  Future<User> _fetchUserData() async{
    return await _userDao.getUser();
  }

  void _setHeaders() async{

    dio.options.headers = {HttpHeaders.authorizationHeader: 'Bearer'};
    return;
  }

  Future<Response> verifyUser(String verificationType) async{
    _setHeaders();
    print("Verifying Login details");
    _user = await _fetchUserData();
    var response = await dio.post(API_VERSION+VERIFY_USER, data: {'type': verificationType,
      'phonenumber': _user.phoneNo, 'username': _user.username});
//    print('Response: ${response.data['flips'][0]}');
    return response;
  }
}