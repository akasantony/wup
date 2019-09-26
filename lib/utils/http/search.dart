import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:wup/utils/constants/api.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/user.dart';

class GetFollowers {
  final Function progressHandler;

  Dio dio = new Dio();
  String firebaseUserId;
  User _user;
  UserDao _userDao = UserDao();


  GetFollowers({this.progressHandler}) {
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

  Future<Map> details({String pattern, List<String> entities}) async {
    _setHeaders();
    print('Dio Headers: ${dio.options.headers}');
    _user = await _fetchUserData();
    var response = await dio.get(API_VERSION + SEARCH + '/' + _user.phoneNo,
        queryParameters: {'pattern': pattern, 'entities': entities},
        onReceiveProgress: progressHandler);
    print('Response Data : ${response.data}');
    return response.data;
  }
}