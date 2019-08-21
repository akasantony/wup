import 'package:flutter/material.dart';
import 'package:wup/Pages/Store/store.dart';
import 'package:wup/Pages/User/flips.dart';
import 'package:wup/Pages/User/profile.dart';
import 'package:wup/Pages/Likes/likes.dart';
import 'dart:core';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  Widget homePage;
  String userImg;
  String imageString;
  TabController _controller;
  bool _flipButtonState = true;
  bool _showPopUpState = false;

  Animation<double> _turns;
  AnimationController _animationController;


  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    _flipButtonState = false;
    super.dispose();
  }

  _onFlipsButtonDragUp (DragUpdateDetails dragUpdateDetails) {
    if(dragUpdateDetails.localPosition.direction.isNegative) {
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => FlipPage(),
        ),
      );
    }
  }

  _onFlipsButtonTap () {
//    _turnsNew = Tween<double>(begin: 0, end: 0.5).animate(_turns);
    _flipButtonState? _animationController.forward(): _animationController.reverse();
    _flipButtonState = !_flipButtonState;
    setState(() {
      _showPopUpState = !_showPopUpState;
    });
    print("Button tapped");
  }

  _showPopUp () {
    if(_showPopUpState) {
      return Container(
        margin: EdgeInsets.only(top: 200),
        color: Colors.transparent,
        width: 100,
        height: 150,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.videocam),
                  Text("Video Flip")
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.image),
                  Text("Image Flip")
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.audiotrack),
                  Text("Audio Flip")
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.gif),
                  Text("Gif Flip")
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ),
          ],
        ),
      );
    }
    else {
      return SizedBox();
    }
  }

  Widget homePageWidget() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10 ),
            child: Row(
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
                      Icon(Icons.person, color: Colors.grey, size: 30,),
                      Text("Profile"),
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
                      Icon(Icons.favorite, color: Colors.grey, size: 30,),
                      Text("3.2k"),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(Icons.store, color: Colors.grey, size: 30,),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => StorePage(),
                          ),
                        );
                      },
                    ),
                    Text("Store", style: TextStyle(),)
                  ],
                ),
              ],
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: TextField(
                decoration: const InputDecoration(hintText: 'Search for users or content'),
              ),
            ),
          ),
          Container(
//            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: TabBar(
              controller: _controller,
              tabs: [
                Tab(
                  icon: const Icon(Icons.ondemand_video),
                  text: 'Feed',
                ),
                Tab(
                  icon: const Icon(Icons.star),
                  text: 'Favourites',
                ),
                Tab(
                  icon: const Icon(Icons.inbox),
                  text: 'Inbox',
                ),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                height: 80.0,
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.home),
                        title: TextField(
                          decoration: const InputDecoration(hintText: 'Search for address...'),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text('Latitude: 48.09342\nLongitude: 11.23403'),
                        trailing: IconButton(icon: const Icon(Icons.my_location), onPressed: () {}),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text('Latitude: 48.09342\nLongitude: 11.23403'),
                        trailing: IconButton(icon: const Icon(Icons.my_location), onPressed: () {
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 340),
                      child: GestureDetector(
                        child: RotationTransition(
                          turns: _animationController,
                          child: Icon(Icons.camera, size: 90, color: Colors.redAccent,),
                        ),
                        onVerticalDragUpdate: _onFlipsButtonDragUp,
                        onTap: _onFlipsButtonTap,
                      ),
                    ),
                    _showPopUp(),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.only(top: 40.0),
        child: homePageWidget(),
//        PageView(
//          controller: PageController(
//            initialPage: 0,
//            viewportFraction: 1,
//          ),
//          children: <Widget>[
//            homePageWidget(),
//            FlipPage()
//          ],
//          scrollDirection: Axis.vertical,
//        ),
      ),
    );
  }
}