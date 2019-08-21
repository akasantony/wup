import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wup/Pages/welcome.dart';
import 'dart:core';

class FlipPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _FlipPageState();
}

class _FlipPageState extends State<FlipPage> with SingleTickerProviderStateMixin{
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  VoidCallback listener;

  _FlipPageState() {
    listener = () {
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
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


  Widget bodyBuilder () {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: Colors.black,
          child: Center(
            child: AspectRatio(
              aspectRatio: 2160/4000,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.person, size: 40, color: Colors.white,),
                    Text("@hotie_megha", style: TextStyle(color: Colors.white),)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.favorite, size: 40, color: Colors.white),
                    Text("3.2k", style: TextStyle(color: Colors.white),)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.add_comment, size: 40, color: Colors.white),
                    Text("400", style: TextStyle(color: Colors.white),)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.share, size: 40, color: Colors.white,),
                    Text("400k", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child:
          PageView(
            controller: PageController(
              initialPage: 0,
              viewportFraction: 1,
            ),
            children: <Widget>[
              bodyBuilder(),
              WelcomePage()
            ],
            scrollDirection: Axis.horizontal,
          ),
        ),
    );
  }
}