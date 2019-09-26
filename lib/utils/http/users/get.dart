import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:wup/utils/constants/api.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/user.dart';

class GetUsers {
  final Function progressHandler;

  Dio dio = new Dio();
  String firebaseUserId;
  User _user;
  UserDao _userDao = UserDao();


  GetUsers({this.progressHandler}) {
    dio.options.baseUrl = DOMAIN;

  }

  Future<User> _fetchUserData() async{
    return await _userDao.getUser();
  }

  void _setHeaders() async{
    await FirebaseAuth.instance.currentUser().then((firebaseUser) async{
      firebaseUser.getIdToken().then((firebaseTokenIdResult) {
        firebaseUserId = firebaseTokenIdResult.token;
      });
    });
    dio.options.headers = {HttpHeaders.authorizationHeader: 'Bearer $firebaseUserId'};
    return;
  }

  Future<Map> getDetails() async{
    _setHeaders();
    _user = await _fetchUserData();
    var response = await dio.get(API_VERSION+USER+'/'+_user.phoneNo, queryParameters: {'user': _user.phoneNo} , onReceiveProgress: progressHandler);
//    print('Response: ${response.data['flips'][0]}');
    return response.data;
  }
}