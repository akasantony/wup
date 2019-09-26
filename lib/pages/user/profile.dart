import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wup/pages/user/series/create.dart';
import 'package:wup/pages/user/series/series.dart';
import 'package:dio/dio.dart';
import 'package:wup/utils/animations/loader.dart';
import 'dart:core';
import 'package:wup/utils/http/users/get.dart';

class ProfilePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin{

  String userImg;
  String imageString;
  TabController _controller;
  PanelController _panelController;
  GetUsers _getUsers;
  Map _userData;
  bool _isUserDetailsLoaded = false;


  @override
  void initState() {
    _getUsers = GetUsers(progressHandler: _progressHandler);
    _controller = new TabController(length: 2, vsync: this);
    _panelController = PanelController();
    _getProfileDetails().then((data) {
      _userData = data;
    });
    super.initState();
  }

  void _progressHandler(int current, int total) {

  }

  Future<Map> _getProfileDetails() async {
    var _userData = await _getUsers.getDetails();
    setState(() {
      print('Data Loaded :'+_userData['flips'].length.toString());
      _isUserDetailsLoaded = true;
    });
    return _userData;
  }

  Widget profilePageBuilder(){
    if(!_isUserDetailsLoaded) {
      return Container(
        color: Colors.green,
        child: Center(
            child: ColorLoader(),
        ),
      );
    }
    else {
      return Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(-1, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: _isUserDetailsLoaded?NetworkImage(_userData['userdata']['profile']['profileimage'], scale: 1):Icon(Icons.account_circle, size: 20,),
                        ),
                      ),
                      Text(_userData['userdata']['profile']['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(_userData['userdata']['profile']['username'])
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 60,
              margin: const EdgeInsets.only(top:10),
              padding: const EdgeInsets.only(top:5),
//            padding: const EdgeInsets.only(left: 40, right: 40),
              decoration: BoxDecoration(
                  color: Colors.white70
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("123", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text("Followers", style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("43", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text("Following", style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("40", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text("Posts", style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
//            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: TabBar(
                controller: _controller,
                tabs: [
                  Tab(
                    icon: Icon(Icons.camera),
                    text: 'My Flips',
                  ),
                  Tab(
                    icon: Icon(Icons.ondemand_video),
                    text: 'My Series',
                  )
                ],
              ),
            ),
            Expanded(
//            height: 650,
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  Container(
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 4.0,
                      padding: const EdgeInsets.all(10),
                      children: _userData['flips'].length != 0?_userData['flips'].map((flipData) {
                        print(_userData['flips']);
                        return Container(
                          width: 200,
                          padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
  //                          shape: BoxShape.rectangle,
  //                          border: Border.all(color: Colors.redAccent),
                            ),
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Container(

                                    child: FittedBox(
                                      child: Image.network(flipData['meta']['mediathumbnail']),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: flipData['meta']['mediatype'] == 'image'?Icon(Icons.image, size: 20, color: Colors.white,):Icon(Icons.videocam, size: 20, color: Colors.white,),
                                  ),
                                )
                              ],
                            ),
                          );
                      }).cast<Widget>().toList():[Container()],
                    ),
                  ),
                  Card(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 60,
                            margin: EdgeInsets.all(10),
                            child: RaisedButton(
                                onPressed: (){
                                  _panelController.open();
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Icon(Icons.add_circle_outline, color: Colors.white, size: 20,),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text("New", style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          ListTile(
                            onTap: (){
                              Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) => SeriesPage(),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              radius: 40.0,
                              backgroundImage: NetworkImage("https://images-na.ssl-images-amazon.com/images/I/61daG4%2BsNPL._UL1000_.jpg"),
                            ),
                            title: Text('Nike Shoes Black'),
                            trailing: Text("1,000"),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SlidingUpPanel(
        maxHeight: 400,
        minHeight: 0,
        color: Colors.red,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        controller: _panelController,
        panel: UploadSeriesPage(),
        body: profilePageBuilder(),
      ),
    );
  }
}