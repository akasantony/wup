import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:video_player/video_player.dart';
import 'dart:core';

class VideoPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with SingleTickerProviderStateMixin{
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(
      'https://www.dropbox.com/s/ekgjyomoh1x1m7n/VID_20190820_205535.mp4?dl=1',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();

    // Use the controller to loop the video.
    _videoPlayerController.setLooping(true);
    setState(() {
      _videoPlayerController.play();
    });

    super.initState();

  }



  Widget videoPageBuilder(){
    return Container(
      margin: EdgeInsets.only(top:25),
//      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
//            width: 300,
            child: VideoPlayer(_videoPlayerController),
          ),
          Container(
            child: ExpandablePanel(
              header: Text("Title"),
//              collapsed: Text(article.body, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
              expanded: Text("Some text about the descruption of this video", softWrap: true, ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(Icons.visibility, size: 20,),
                    Text("123", style: TextStyle(fontSize: 15.0,)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Icon(Icons.favorite_border),
                    Text("123", style: TextStyle(fontSize: 15.0,)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Icon(Icons.share),
                    Text("Share", style: TextStyle(fontSize: 15.0)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: Card(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage("https://images-na.ssl-images-amazon.com/images/I/61daG4%2BsNPL._UL1000_.jpg"),
                  ),
                  Column(
                    children: <Widget>[
                      Text("@hottie_meghan"),
                      Text("#MotorcycleDiaries")
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 200.0,
                        height: 40.0,
                        child: RaisedButton(
                            onPressed: (){
//                              _panelController.open();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.red,
                            child:                                 Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Subscribe", style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                        ),
                      ),
                      Container(
                        child: Text("12k"),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: videoPageBuilder(),
    );
  }
}