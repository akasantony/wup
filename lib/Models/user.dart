import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:quib/Utils/Media/image_store.dart';

class CurrentUserInfo {

  String _userID;
  String _phoneNo;
  String _userName;
  String _userFirstName;
  String _userLastName;
  String _userPassword;
  String _userEmail;
  String _userGender;
  String _userProfession;
  String _userInstitution;
  int _userDateOfBirth;
  String _userProfileImagePath;
  String _userBio;
  String _firebaseAuthToken;
  List<String> _userInterests;

  CurrentUserInfo() {
    this._userDateOfBirth = 123;
  }

  String getUserName() {
    return this._userName;
  }

  String getUserPhoneNo() {
    return this._phoneNo;
  }

  String getUserID() {
    return this._userID;
  }

  String getUserFirstName() {
    return this._userFirstName;
  }

  String getUserLastName() {
    return this._userLastName;
  }

  String getUserPassword() {
    return this._userPassword;
  }

  String getUserEmail() {
    return this._userEmail;
  }

  String getUserGender() {
    return this._userGender;
  }

  String getUserProfession() {
    return this._userProfession;
  }

  String getUserInstitution() {
    return this._userInstitution;
  }

  int getUserAge(){

    return ((DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(this._userDateOfBirth)).inDays)/365).floor();
  }

  int getUserDateOfBirth() {
    return this._userDateOfBirth;
  }

  String getUserProfileImagePath() {
    return this._userProfileImagePath;
  }

  List<String> getUserInterests() {
    return this._userInterests;
  }

  String getUserBio() {
    return this._userBio;
  }

  String getFirebaseAuthToken() {
    return this._firebaseAuthToken;
  }

  void setUserID(String userID) {
    this._userID = userID;
  }

  void setUserFirstName(String name) {
    this._userFirstName = name;
  }

  void setUserLastName(String name) {
    this._userLastName = name;
  }

  void setUserPassword(String password) {
    this._userPassword = password;
  }

  void setUserEmail(String email) {
    this._userEmail = email;
  }

  void setUserGender(String gender) {
    this._userGender = gender;
  }

  void setUserProfession(String profession) {
    this._userProfession = profession;
  }

  void setUserInstitution(String institution) {
    this._userInstitution = institution;
  }

  void setUserDateOfBirth(int dateOfBirth) {
    this._userDateOfBirth = dateOfBirth;
  }

  void setUserInterests(List<String> interests) {
    this._userInterests = interests;
  }

  void setUserProfileImagePath(String imagePath) {
    this._userProfileImagePath = imagePath;
  }

  void setUserBio(String userBio) {
    this._userBio = userBio;
  }

  void setFirebaseAuthToken(String authToken) {
    this._firebaseAuthToken = authToken;
  }

  void setUserName(String userName) {
    this._userName = userName;
  }

  void setUserPhoneNo(String phoneNo) {
    this._phoneNo = phoneNo;
  }

  Map<String, dynamic> mapUser() {
    return {
      'user_name': this._userName,
      'user_phone_no': this._phoneNo,
      'user_id': this._userID,
      'user_first_name': this._userFirstName,
      'user_last_name': this._userLastName,
      'user_email': this._userEmail,
      'user_password': this._userPassword,
      'user_gender': this._userGender,
      'user_date_of_birth': this._userDateOfBirth.toString(),
      'user_profile_image_path': this._userProfileImagePath,
      'user_firebase_auth_id': this._firebaseAuthToken
    };
  }

  void setUserMapping(Map<String, dynamic> mappedUserData) {
    this.setUserName(mappedUserData['user_name']);
    this.setUserPhoneNo(mappedUserData['user_phone_no']);
    this.setUserID(mappedUserData['user_id']);
    this.setUserProfileImagePath(mappedUserData['user_profile_image_path']);
    this.setUserFirstName(mappedUserData['user_first_name']);
    this.setUserLastName(mappedUserData['user_last_name']);
    this.setUserEmail(mappedUserData['user_email']);
    this.setUserPassword(mappedUserData['user_password']);
    this.setUserGender(mappedUserData['user_gender']);
    this.setUserDateOfBirth(int.parse(mappedUserData['user_date_of_birth']));
    this.setFirebaseAuthToken(mappedUserData['user_firebase_auth_id']);
  }
}