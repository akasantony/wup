import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wup/utils/constants/api.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/user.dart';

class UpdateFlip {
  final Function progressHandler;

  Dio dio = new Dio();
  String firebaseUserId;


  UpdateFlip({this.progressHandler}) {
    dio.options.baseUrl = DOMAIN;

  }

  Future _setHeaders() async{
    await FirebaseAuth.instance.currentUser().then((firebaseUser) async{
      firebaseUser.getIdToken().then((firebaseTokenIdResult) {
        firebaseUserId = firebaseTokenIdResult.token;
      });
    });
    dio.options.headers = {HttpHeaders.authorizationHeader: 'Bearer $firebaseUserId'};
    return;
  }

  Future<Map> update(String flipID, Map updateData) async{
    print("Updating Flips: ");
    print(updateData);
    await _setHeaders();
    var response = await dio.put(API_VERSION+FLIP+'/'+flipID, data: updateData , onReceiveProgress: progressHandler);
//    print('Response: ${response.data['flips'][0]}');
    return response.data;
  }
}