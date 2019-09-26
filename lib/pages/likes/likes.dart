import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:core';

class LikesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> with SingleTickerProviderStateMixin{

  Widget LikesPage;
  String userImg;
  String imageString;
  TabController _tabController;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  VoidCallback listener;

  _LikesPageState() {
    listener = () {
      setState(() {});
    };
  }


  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();

    _controller = VideoPlayerController.network(
      'https://www.dropbox.com/s/ekgjyomoh1x1m7n/VID_20190820_205535.mp4?dl=1',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    setState(() {
      _controller.play();
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    super.dispose();
    _controller.dispose();
  }

  @override
  void deactivate() {
    _controller.setVolume(0.0);
    _controller.removeListener(listener);
    super.deactivate();
  }


  Widget likesPageBuilder(){
      return Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
                      gradient: LinearGradient(
                          colors: [Colors.red, Colors.yellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                      )
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top:200,),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("203,400", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white, fontStyle: FontStyle.italic),),
                          Icon(Icons.favorite, color: Colors.redAccent, size: 120,)
                        ],
                      ),
                    )
                ),
              ],
            ),
            Container(
//            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.favorite_border),
                    text: 'Watch',
                  ),
                  Tab(
                    icon: const Icon(Icons.credit_card),
                    text: 'Buy',
                  ),
                ],
              ),
            ),
            Container(
              height: 80.0,
              child: TabBarView(
                controller: _tabController,
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
                ],
              ),
            ),
          ],
        )
      );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 40.0),
            child: likesPageBuilder(),
          ),
        )
    );
  }
}
