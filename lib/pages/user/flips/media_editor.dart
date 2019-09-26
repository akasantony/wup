import 'package:dio/dio.dart' as prefix0;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:http/http.dart' as http;
import 'package:wup/Pages/User/Flips/meta.dart';
import 'package:wup/Pages/User/profile.dart';
import 'package:wup/utils/constants/flips.dart';
import 'dart:core';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:wup/utils/constants/media.dart';
import 'package:wup/utils/database/dao/flips_dao.dart';
import 'package:wup/utils/database/dao/user_dao.dart';
import 'package:wup/utils/database/models/flips.dart';
import 'package:wup/utils/database/models/user.dart';
import 'package:wup/utils/http/flips/add.dart';

class MediaEditorPage extends StatefulWidget {
  final String mediaFilePath;
  final MediaType mediaType;

  const MediaEditorPage({Key key, @required this.mediaFilePath, @required this.mediaType}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MediaEditorPageState();
}

class _MediaEditorPageState extends State<MediaEditorPage> with SingleTickerProviderStateMixin{
  PanelController _slideUpPanelController;
  VideoPlayerController _videoController;
  Future<void> _initializeVideoPlayerFuture;
  VoidCallback listener;
  TabController _imageEditorTabController;
  Color _audioColor = Colors.white;
  Color _filterColor = Colors.grey;
  Color _stickersColor = Colors.grey;
  Widget _stickersWidgetHolder;
  RangeValues _rangeSlider = RangeValues(4, 5);
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  String _imageFilePath = '';
  VideoPlayerController _newVideoController;
  FlipsDao _flipsDao = FlipsDao();
  Flips _flips;
  AddFlips _addFlips;
  Widget _slideUpWidget;
  final String assetName = 'assets/media/images/stickers/disguise.svg';


  _MediaEditorPageState() {
    listener = () {
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    _imageFilePath = widget.mediaFilePath;
    _slideUpPanelController = PanelController();

    _imageFilePath = widget.mediaFilePath;

    _stickersWidgetHolder = _stickerDisplayWidget();
    _imageEditorTabController = new TabController(length: 3, vsync: this);
    _imageEditorTabController.addListener(_tabChangeListener);
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _videoController = VideoPlayerController.file(File(_imageFilePath));

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _videoController.initialize();

    // Use the controller to loop the video.
    _videoController.setLooping(true);

    setState(() {
      _videoController.play();
    });
  }

  void _tabChangeListener() {
    print(_imageEditorTabController.index);
    switch(_imageEditorTabController.index) {
      case 0:
        setState(() {
          _audioColor = Colors.white;
          _filterColor = Colors.grey;
          _stickersColor = Colors.grey;
        });
        break;

      case 1:
        setState(() {
          _audioColor = Colors.grey;
          _filterColor = Colors.white;
          _stickersColor = Colors.grey;
        });
        break;

      case 2:
        setState(() {
          _audioColor = Colors.grey;
          _filterColor = Colors.grey;
          _stickersColor = Colors.white;
        });
        break;
    }
  }


  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    super.dispose();
    _videoController.dispose();
  }

  @override
  void deactivate() {
    _videoController.setVolume(0.0);
    _videoController.removeListener(listener);
    super.deactivate();
  }

  void _doneEditingPressed(_postMeta) {
  }


  Widget _stickerEditWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            height: 10,
            child: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){}),
          ),
          Container(
            child: Container(),
          ),
          RangeSlider(
            min: 1,
            max: 15,
            values: _rangeSlider,
            onChanged: (rangeValues){
              setState(() {
                _rangeSlider = rangeValues;
                print("${_rangeSlider.start} ${_rangeSlider.end}");
              });
            },
          ),
        ],
      ),
    );
  }

  Future<String> _onStickerTapped(String _stickerUrl) async{
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/tmp/image_flips';
    final String gifDirectory = '${appDirectory.path}/tmp/stickers';

    final exrernalDirectory = await getExternalStorageDirectory();
    final myImagePath = '${exrernalDirectory.path}/flips/';
    await Directory(myImagePath).create(recursive: true);

    ByteData data = await rootBundle.load(_stickerUrl);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await Directory(videoDirectory).create(recursive: true);
    await Directory(gifDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    _imageFilePath = '$myImagePath/$currentTime.png';
    print(_imageFilePath);
    final String stickerFilePath = '$gifDirectory/$currentTime.svg';

    await File(stickerFilePath).writeAsBytes(bytes);
    _stickersWidgetHolder = _stickerEditWidget();
    var results = await _flutterFFmpeg.execute("-y -threads 2 -i ${widget.mediaFilePath}  $stickerFilePath $_imageFilePath");
    return _imageFilePath;
  }


  Widget _stickerDisplayWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: TextField(
                decoration: const InputDecoration(hintText: 'Search'),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(100, (index) {
                return GestureDetector(
                  onTap: (){
                    var _stickerId = "https://media.giphy.com/media/1iZRZx0t1h6zxl28/giphy.gif";
                    setState(() {
                      _onStickerTapped(assetName);
                    });
                  },
                  child: SvgPicture.asset(
                      assetName,
                      color: Colors.white,

                      semanticsLabel: 'A red up arrow'
                  ),
                );
              }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageEffectsChooser(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: TabBar(
              controller: _imageEditorTabController,
              tabs: [
                Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star_border, color: _audioColor, size: 20,),
                    ),
                ),
                Tab(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.filter_b_and_w, color: _filterColor, size: 20,),
                        ),
                        Container(
                          child: Text("Filters", style: TextStyle(
                              color: _filterColor, fontWeight: FontWeight.bold, fontSize: 10.0
                          ),),
                        )
                      ],
                    )
                ),
                Tab(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.filter_center_focus, color: _stickersColor, size: 20,),
                        ),
                        Container(
                          child: Text("Stickers", style: TextStyle(
                            color: _stickersColor, fontWeight: FontWeight.bold, fontSize: 10,
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black26,
              child: TabBarView(
                controller: _imageEditorTabController,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 170,
                          child: RaisedButton(
                              onPressed: (){
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Icon(Icons.music_note, color: Colors.white, size: 20,),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text("Add Sound", style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Text("Video"),
                  ),
                  _stickersWidgetHolder,
                ],
              ),
            ),
          ),
        ],
      )

    );
  }

  Widget _collapsedWidget() {
    return Container();
  }

  Future<String> _generateThumbnail(filePath) async{
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String imageDirectory = '${appDirectory.path}/tmp/images/thumbnail';
    await Directory(imageDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String thumbnailPath  = '$imageDirectory/$currentTime.jpg';

    var ffmpegCommand = '-i $filePath -ss 00:00:10 -vframes 1 $thumbnailPath';
    var status = await _flutterFFmpeg.execute(ffmpegCommand);
    if(status == 0) {
      return thumbnailPath;
    }
    else{
      throw 'FFMPEG conversion error';
    }
  }

  void _postHandler(_postMeta) async {
    var flipsData = {};
    var thumbnailPath = await _generateThumbnail(widget.mediaFilePath);
     switch(_postMeta['visibility']) {
       case VisibilityStatus.public:
         flipsData['visibility'] = 'public';
         break;
       case VisibilityStatus.mutual:
         flipsData['visibility'] = 'mutual';
         break;
       case VisibilityStatus.followers:
         flipsData['visibility'] = 'followers';
         break;
     }

     switch(_postMeta['mediatype']) {
       case MediaType.image:
         flipsData['mediatype'] = 'image';
         break;
       case MediaType.video:
         flipsData['mediatype'] = 'video';
         flipsData['mediathumbnailpath'] = thumbnailPath;
         break;
     }

     flipsData['description'] = _postMeta['description'];
     final int currentTime = DateTime.now().millisecondsSinceEpoch;
     flipsData['timestamp'] = currentTime;
     flipsData['mediafilepath'] = widget.mediaFilePath;

     _flips = Flips.fromMap(flipsData.cast<String, dynamic>());
     print("Flips: ${_flips.toMap()}");
     _addFlips = AddFlips(progressHandler: _progressHandler);
     await _flipsDao.insert(_flips);
     var _response = await _addFlips.createFlip();
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ProfilePage()));
  }

  void _getImageFlipMeta() {
    showDialog(
      context: context,
      builder: (_) => MetaDialogue(onPost: _postHandler, mediaType: MediaType.image),
    );
  }

  void _progressHandler(int sent, int total) {
    print(sent/total);
  }

  void _getVideoFlipMeta() {
    showDialog(
      context: context,
      builder: (_) => MetaDialogue(onPost: _postHandler, mediaType: MediaType.video),
    );
  }

  Widget _imageEditor() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
//            color: Colors.black87,
//            height: MediaQuery.of(context).size.height,
            child: Image.file(File(_imageFilePath), height: MediaQuery.of(context).size.height, fit: BoxFit.fill,),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.only(top:70, right: 20),
//              height: 50,
//              width: 50,
              child: Column(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.tune, color: Colors.white, size: 30,),
                      onPressed: (){
                        if(_slideUpPanelController.isPanelOpen()) {
                          _slideUpPanelController.close();
                        }
                        else if(_slideUpPanelController.isPanelClosed()){
                          setState(() {
                            _slideUpWidget = _imageEffectsChooser();
                          });
                          _slideUpPanelController.open();
                        }
                      }
                    ),
                  Text("Effects", style: TextStyle(color: Colors.white)
                  ),
                ],
              )
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 20, bottom: 20),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
//                border: Border.all(color: Colors.white, width: 2)
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.clear,),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 20, bottom: 20),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
//                  border: Border.all(color: Colors.white, width: 2)
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.check,),
                  color: Colors.white,
                  onPressed: _getImageFlipMeta,
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _videoEditor() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black87,
            height: MediaQuery.of(context).size.height,
            child: VideoPlayer(_videoController),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
                margin: const EdgeInsets.only(left: 20, bottom: 10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
//                border: Border.all(color: Colors.white, width: 2)
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.clear,),
                    color: Colors.redAccent,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                margin: const EdgeInsets.only(right: 20, bottom: 10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
//                  border: Border.all(color: Colors.white, width: 2)
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.check,),
                    color: Colors.lightGreenAccent,
                    onPressed: _getVideoFlipMeta,
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyBuilder() {
    if(widget.mediaType == MediaType.image) {
      return _imageEditor();
    }
    else if(widget.mediaType == MediaType.video) {
      return _videoEditor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: 500,
        minHeight: 0,
        color: Colors.black45,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        controller: _slideUpPanelController,
        collapsed: _collapsedWidget(),
        panel: _slideUpWidget,
        body: _bodyBuilder(),
      ),
    );
  }
}