import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:wup/utils/constants/api.dart';
import 'package:wup/utils/database/dao/flips_dao.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/flips.dart';
import 'package:wup/utils/database/models/user.dart';

class AddFlips {
  final Function progressHandler;

  Dio dio = new Dio();
  String firebaseUserId;
  FlipsDao _flipsDao = FlipsDao();
  Flips _flips;
  User _user;
  UserDao _userDao = UserDao();


  AddFlips({this.progressHandler}) {
    dio.options.baseUrl = DOMAIN;

  }

  bool validateData(_flipData) {
    return true;
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

  Future<Flips> _fetchFlipsData() async{
    return await _flipsDao.getFlips();
  }

  Future<User> _fetchUserData() async{
    return await _userDao.getUser();
  }

  FormData _generateFormData() {
    File mediaFile = File(_flips.mediaFilePath);
    if(_flips.mediaType == 'image') {
      return FormData.from({
        'user': _user.phoneNo,
        'mediatype': _flips.mediaType,
        'timestamp': _flips.timestamp,
        'description': _flips.description,
        'visibility': _flips.visibility,
        'flipsmedia': new UploadFileInfo(mediaFile, basename(mediaFile.path)),
      });
    }
    else if(_flips.mediaType == 'video') {
      File mediaThumbnailFile = File(_flips.mediaThumbnailPath);
      return FormData.from({
        'user': _user.phoneNo,
        'mediatype': _flips.mediaType,
        'timestamp': _flips.timestamp,
        'description': _flips.description,
        'visibility': _flips.visibility,
        'flipsmedia': new UploadFileInfo(mediaFile, basename(mediaFile.path)),
        'flipsthumbnail': new UploadFileInfo(mediaThumbnailFile, basename(mediaThumbnailFile.path)),
      });
    }
    else {
      return FormData();
    }
  }

  Future createFlip() async{
    _flips = await _fetchFlipsData();
    _user = await _fetchUserData();
    print(_flips.toMap());
    if(validateData(_flips)) {
      _setHeaders();
      var response = await dio.post(API_VERSION+FLIP, data: _generateFormData(), onReceiveProgress: progressHandler);
      if(response.statusCode == 200) {
        print((response.data));
        var respJson = response.data;
        return respJson;
      }
    }
  }
}