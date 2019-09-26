import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wup/Pages/welcome.dart';
import 'package:wup/Pages/Store/store.dart';
import 'package:wup/Pages/User/profile.dart';
import 'package:wup/Pages/Likes/likes.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/user.dart';
import 'dart:core';

import 'package:wup/utils/http/flips/update.dart';

class FlipPage extends StatefulWidget {
  final List<dynamic> flipsData;

  FlipPage({Key key, this.flipsData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FlipPageState();
}

class _FlipPageState extends State<FlipPage> with SingleTickerProviderStateMixin{
  VideoPlayerController _controller;
  VoidCallback listener;
  AnimationController _menuAnimationController;
  bool _isShowingMenu = false;
  double _optionsMenuHeight = 0;
  UpdateFlip _updateFlip;
  UserDao _userDao = UserDao();
  User _user;

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
    _menuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _controller = VideoPlayerController.network(
      'https://www.dropbox.com/s/ekgjyomoh1x1m7n/VID_20190820_205535.mp4?dl=1',
    );

    // Initialize the controller and store the Future for later use.
    _controller.initialize().then((values) {

    });

    // Use the controller to loop the video.
    _controller.setLooping(true);
    _updateFlip = UpdateFlip(progressHandler: _updateFlipProgress);

  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    super.dispose();
    _menuAnimationController.dispose();
    _controller.dispose();
  }

  @override
  void deactivate() {
    _controller.setVolume(0.0);
    _controller.removeListener(listener);
    super.deactivate();
  }

  void _updateFlipProgress(int start, int total) {

  }

  void _onPageChanged(pageNo) {
    _controller.dispose();
    _controller = VideoPlayerController.network('https://www.dropbox.com/s/ekgjyomoh1x1m7n/VID_20190820_205535.mp4?dl=1',);
    _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }


  Widget _showAdditionalOptionsController({String commentCount, String shareCount}) {
    if(_isShowingMenu) {
      _optionsMenuHeight = 120;
    }
    else{
      _optionsMenuHeight = 0;
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: _optionsMenuHeight,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_comment, size: 40, color: Colors.white),
                  onPressed: () {

                  },
                ),
                Text(commentCount, style: TextStyle(color: Colors.white),)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.share, size: 40, color: Colors.white,),
                  onPressed: () {

                  },
                ),
                Text(shareCount, style: TextStyle(color: Colors.white),)
              ],
            ),
          ],
        ),
      )
    );
  }

  void _updateFlipHandler(String flipID,  Map updateData) async{
    await _updateFlip.update(flipID, updateData);
  }

  List<Widget> bodyBuilder () {
    var flipsData = widget.flipsData.toList();
    return flipsData.map((flip) {
      print("Flip Data: ");
      print(flip);
      if(flip['value']['meta']['mediatype'] == 'image') {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Image.network(flip['value']['meta']['mediaurl'])
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(flip['profileimageurl'], scale: 2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: flip['liked']? Icon(Icons.favorite, size: 40, color: Colors.white):Icon(Icons.favorite_border, size: 40, color: Colors.white),
                                onPressed: () async{
                                  _user = await _userDao.getUser();
                                  String flipId = flip['value']['id'];
                                  var updateData;
                                  if(!flip['liked']) {
                                    updateData = {
                                      "entity": 'like',
                                      'value': 1,
                                      'userid': _user.phoneNo,
                                      'actions': ['incrementvalue'],
                                      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                                    };
                                    setState(() {
                                      flip['value']['likescount'] = flip['value']['likescount']+1;
                                    });
                                  }
                                  else {
                                    updateData = {
                                      "entity": 'like',
                                      'value': 1,
                                      'userid': _user.phoneNo,
                                      'actions': ['decrementvalue'],
                                      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                                    };
                                    setState(() {
                                      flip['value']['likescount'] = flip['value']['likescount']-1;
                                    });
                                  }
                                  setState(() {
                                    flip['liked'] = !flip['liked'];
                                  });

                                  _updateFlipHandler(flipId, updateData);
                                },
                              ),
                              Text(flip['value']['likescount'].toString(), style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                        _showAdditionalOptionsController(commentCount: flip['value']['commentscount'].toString(), shareCount: flip['value']['sharescount'].toString()),
                        Container(
                            margin: const EdgeInsets.all(10),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1)
                            ),
                            child: Center(
                              child: IconButton(
                                iconSize: 20,
                                icon: AnimatedIcon(
                                  color: Colors.white,
                                  icon: AnimatedIcons.menu_close,
                                  progress: _menuAnimationController,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if(!_isShowingMenu) {
                                      _menuAnimationController.forward();
                                    }else {
                                      _menuAnimationController.reverse();
                                    }
                                    _isShowingMenu = !_isShowingMenu;
                                  });
                                },
                              ),
                            )
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
        );
      }
      else if(flip['value']['meta']['mediatype']== 'video'){
        return Container(
          padding: EdgeInsets.all(10),
          child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 25,
                          //                        backgroundColor: Colors.white,
                          backgroundImage: NetworkImage("https://in.bmscdn.com/iedb/artist/images/website/poster/large/margot-robbie-38083-28-01-2019-10-59-34.jpg", scale: 1),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.favorite_border, size: 40, color: Colors.white),
                        Text("3.2k", style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                  _showAdditionalOptionsController(),
                  Container(
                      margin: const EdgeInsets.all(10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        //                      color: Colors.lightGreenAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1)
                      ),
                      child: Center(
                        child: IconButton(
                          iconSize: 20,
                          icon: AnimatedIcon(
                            color: Colors.white,
                            icon: AnimatedIcons.menu_close,
                            progress: _menuAnimationController,
                          ),
                          onPressed: () {
                            setState(() {
                              if(!_isShowingMenu) {
                                _menuAnimationController.forward();
                              }else {
                                _menuAnimationController.reverse();
                              }
                              _isShowingMenu = !_isShowingMenu;
                            });
                          },
                        ),
                      )
                  ),
                ],
              )
          ),
        );
      }
      return Container();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child:
          PageView(
            onPageChanged: _onPageChanged,
            controller: PageController(
              initialPage: 0,
              viewportFraction: 1,
            ),
            children: bodyBuilder(),
            scrollDirection: Axis.horizontal,
          ),
        ),
    );
  }
}