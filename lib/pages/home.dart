import 'package:flutter/material.dart';
import 'package:wup/pages/Store/store.dart';
import 'package:wup/pages/User/inbox/inbox.dart';
import 'package:wup/pages/User/profile.dart';
import 'package:wup/pages/Likes/likes.dart';
import 'package:wup/pages/user/flips/create.dart';
import 'package:countdown/countdown.dart';
import 'package:camera/camera.dart';
import 'dart:core';

import 'package:wup/pages/search/search.dart';
import 'package:wup/pages/user/flips/flips.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/user.dart';
import 'package:wup/utils/http/feed.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  Widget homePage;
  String userImg;
  String imageString;
  bool _createButtonWidgetVisibility = true;
  UserDao _userDao = UserDao();
  User _user;
  bool _isDataLoaded = false;
  List<dynamic> flipsData;


  @override
  void initState() {
    super.initState();
    _showCreateButton();
    _getUserFeed().then((data) {
      setState(() {
        flipsData = data['feedlist'];
        _isDataLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _progressHandler(int current, int total) {

  }

  Future<Map> _getUserFeed() async{
    _user = await _userDao.getUser();
    var getFeed = GetFeed(progressHandler: _progressHandler);
    return await getFeed.details(paginateStartRange: 0, paginateEndRange: 30, feedType: 'public');

  }

  _onFlipsButtonTap () async{
    final cameraDescription = await availableCameras();
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => CreateFlipPage(cameraDescription: cameraDescription,),
      ),
    );
    print("Button tapped");
  }

  Widget _createButtonWidget() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: _createButtonWidgetVisibility ? 1.0 : 0.0,
      child: Align(
          alignment: Alignment.bottomCenter ,
        child: Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white)
          ),
          child: IconButton(icon: Icon(Icons.add_circle, color: Colors.white, size: 50,), onPressed: _onFlipsButtonTap),
        )
      ),
    );
  }

  void _showCreateButton() {
    var sub;
    CountDown _countDown = CountDown(Duration(seconds: 3), refresh: Duration(seconds: 1));
    setState(() {
      _createButtonWidgetVisibility = true;
    });
    sub = _countDown.stream.listen(null);
    sub.onDone(() {
      setState(() {
        _createButtonWidgetVisibility = false;
      });
    });
  }

  Widget homePageWidget() {
    if(_isDataLoaded) {
      return Stack(
        children: <Widget>[
          GestureDetector(
            onTap: _showCreateButton,
            child: FlipPage(flipsData: flipsData,),
          ),
          _createButtonWidget()
        ],
      );
    }
  }

  Widget _bottomNavigationBarBuilder() {
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.person, color: Colors.grey),
                  Text("Profile", style: TextStyle(color: Colors.black, fontSize: 10),),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.search, color: Colors.grey),
                  Text("Search", style: TextStyle(color: Colors.black, fontSize: 10),),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => LikesPage(),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.favorite, color: Colors.red, size: 30,),
                  Text("3.2k", style: TextStyle(color: Colors.black, fontSize: 10)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => InboxPage(),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.mail, color: Colors.grey),
                  Text("Inbox", style: TextStyle(color: Colors.black, fontSize: 10)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => StorePage(),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.store, color: Colors.grey),
                  Text("Store", style: TextStyle(color: Colors.black, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
//            appBar: _appBarBuilder(),
            body: homePageWidget(),
          bottomNavigationBar: _bottomNavigationBarBuilder(),
        ),
        onWillPop: () async => true,
    );
  }
}