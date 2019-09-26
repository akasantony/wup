import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wup/utils/constants/api.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/user.dart';

class GetFeed {
  final Function progressHandler;

  Dio dio = new Dio();
  String firebaseUserId;
  User _user;
  UserDao _userDao = UserDao();


  GetFeed({this.progressHandler}) {
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

  Future<Map> details({String feedType, int paginateStartRange, int paginateEndRange}) async {
    _setHeaders();
    print('Dio Headers: ${dio.options.headers}');
    _user = await _fetchUserData();
    print("Feed Type: "+feedType);
    var response = await dio.get(API_VERSION + FEED + '/' + _user.phoneNo,
        queryParameters: {'feedtype': feedType, 'paginatestartrange': paginateStartRange, 'paginateendrange': paginateEndRange},
        onReceiveProgress: progressHandler);
    response.data['userid'] = _user.phoneNo;
    print('Response Data : ${response.data}');
    return response.data;
  }
}