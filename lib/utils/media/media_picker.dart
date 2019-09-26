import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:countdown/countdown.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wup/Pages/User/Flips/media_editor.dart';
import 'package:video_player/video_player.dart';
import 'package:wup/utils/media/image_crop.dart';
import 'package:wup/utils/media/camera.dart';
import 'package:wup/utils/constants/media.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';

class MediaPickerPage extends StatefulWidget {
  final MediaType mediaType;

  const MediaPickerPage({Key key, @required this.mediaType}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage> with SingleTickerProviderStateMixin{

  CameraController _cameraController;
  AppBar appBar;
  double _percentage = 1.0;
  Text _text = Text("Tap to record", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),);
  bool _hasStartedRecording = false;
  var sub;
  Uint8List _byteList = Uint8List(3);

  String _videoFilePath;
  String _videoAction = "record";

  CountDown _countDown = CountDown(Duration(seconds: 15), refresh: Duration(seconds: 1));

  List<CameraDescription> cameras;
  int selectedCameraIdx;

  @override
  void initState() {
    appBar = AppBar();

    availableCameras()
        .then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    })
        .catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });

    Camera(cameras, setImagePreview);

    super.initState();
  }

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (_cameraController != null) {
      await _cameraController.dispose();
    }


    _cameraController = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    _cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (_cameraController.value.hasError) {
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  Future _pausedVideoRecording() async{
    if (!_cameraController.value.isInitialized) {
      return null;
    }

    try {
      await _cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      return null;
    }

  }

  Future _resumedVideoRecording() async{
    print("Resuming video...");
    if (!_cameraController.value.isInitialized) {
      print("Video controller not initialised...");
      return null;
    }

    try {
      await _cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      print(e.code);
      return null;
    }

  }

  Future<String> _startVideoRecording() async {
    if (!_cameraController.value.isInitialized) {

      return null;
    }

    // Do nothing if a recording is on progress
    if (_cameraController.value.isRecordingVideo) {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/tmp/video_flips/';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/${currentTime}.mp4';
    _videoFilePath = filePath;

    _cameraController.addListener(() {

    });

    try {
      await _cameraController.startVideoRecording(filePath);
//      videoPath = filePath;
    } on CameraException catch (e) {
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await _cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      return null;
    }
  }

  void _videoRecordingController() {
    switch (_videoAction) {
      case 'record':
        sub = _countDown.stream.listen(null);
        setState(() {
          _videoAction = 'pause';
        });
        _startVideoRecording().then((onValue) {
          sub.onData((duration) {
            setState(() {
              _percentage = _percentage - ((100/15)/100);
            });
          });
        });
        break;

      case 'pause':
        print("Paused");
        setState(() {
          _videoAction = 'resume';
        });
        sub.pause();
        _pausedVideoRecording().then((onValue) {
        });
        break;

      case 'resume':
        print("Resumed");
        setState(() {
          _videoAction = 'pause';
        });
        sub.resume();
        _resumedVideoRecording().then((onValue) {
          sub.onData((duration) {
            setState(() {
              _percentage = _percentage - ((100/15).floor()/100);
            });
          });
        });
        break;

      case 'stop':
        _stopVideoRecording().then((onValue) {
          print("Done");
          sub.cancel();
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => MediaEditorPage(mediaFilePath: _videoFilePath, mediaType: MediaType.video,),
            ),
          );
        });
    }

    sub.onDone(() {
      _stopVideoRecording().then((onValue) {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => MediaEditorPage(mediaFilePath: _videoFilePath, mediaType: MediaType.video,),
          ),
        );
      });
    });

  }

  void _onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx < cameras.length - 1
        ? selectedCameraIdx + 1
        : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }


  Widget _cameraTogglesRowWidget() {
    if (cameras == null) {
      return Row();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Container(
      child: IconButton(
        onPressed: _onSwitchCamera,
        icon: Icon(
          _getCameraLensIcon(lensDirection), color: Colors.white,
        ),
      ),
    );
  }

  Widget _flashToggleButtonWidget(){
    return IconButton(icon: Icon(Icons.flash_off, size: 20, color: Colors.white,),
        onPressed: null
    );
  }

  Widget _recordToggleButtonWidget() {

    if(!_hasStartedRecording){
      return IconButton(icon: Icon(Icons.camera,color: Colors.redAccent, size: 20,),
        onPressed: (){
          _hasStartedRecording = true;
          _videoRecordingController();
        },
      );
    }

    switch(_videoAction) {
      case 'resume':
        return IconButton(icon: Icon(Icons.camera,color: Colors.redAccent, size: 20,),
          onPressed: (){
            _videoRecordingController();
          },
        );
        break;

      case 'pause':
        return IconButton(icon: Icon(Icons.pause,color: Colors.redAccent, size: 20,),
          onPressed: (){
            _videoRecordingController();
          },
        );
        break;
    }

  }

  void setImagePreview(bytesImage) {
    setState(() {
      _byteList = bytesImage;
    });
  }

  Widget _uploadGalleryWidget(){
    return SizedBox();
  }

  void _takePicture() async{
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String mediaDirectory = '${appDirectory.path}/tmp/media/images';
    await Directory(mediaDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String imagePath = '$mediaDirectory/$currentTime.jpg';
    _cameraController.takePicture(imagePath).then((value) async{
//      Navigator.push(context,
//        MaterialPageRoute(
//            builder: (context) => CropImagePage(inputFile: File(imagePath),)
//        ),
//      );
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagePath,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
        toolbarColor: Colors.redAccent,
        statusBarColor: Colors.deepOrange
      );
      Navigator.pop(context, croppedFile);
    });
  }

  Widget _mediaWidget() {
    switch(widget.mediaType) {
      case MediaType.image:
        return Stack(
          children: <Widget>[
            CameraPreview(_cameraController),
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _cameraTogglesRowWidget(),
                    Container(
                      child: IconButton(icon: Icon(Icons.photo_camera, size: 40, color: Colors.redAccent,),
                        onPressed: () {
                          _takePicture();
                        },
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: 20.0,
                      color: Colors.redAccent,
                    ),
                  ],
                )
            )
          ],
        );
        break;
      case MediaType.video:
        return Stack();
        break;

      default:
        return Stack();
        break;
    }
  }


  Widget _MediaPickerPageWidget() {
    return Container(
//      padding: EdgeInsets.only(top: 20),
//      margin: EdgeInsets.only(left: 5, right: 5),
      height: MediaQuery.of(context).size.height-appBar.preferredSize.height,
      child: _mediaWidget(),
//      child: Stack(
//        children: <Widget>[
//          Container(
//            height: MediaQuery.of(context).size.height-appBar.preferredSize.height,
//            child: _mediaWidget(),
//          ),
//          Container(
//            height: MediaQuery.of(context).size.height-appBar.preferredSize.height,
//            child: TabBarView(
//              controller: _tabController,
//              children: <Widget>[
//                Container(
//                  height: double.infinity,
//                  width: double.infinity,
//                  child: Stack(
//                    children: <Widget>[
//                      CameraPreview(_cameraController),
//                      Container(
//                        margin: EdgeInsets.only(bottom: 20),
//                        child: Align(
//                          alignment: Alignment.bottomCenter,
//                          child: IconButton(icon: Icon(Icons.camera, size: 90, color: Colors.redAccent,),
//                            onPressed: (){
//
//                            },
//                          ),
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//                Container(
//                  height: MediaQuery.of(context).size.height,
//                  child: Stack(
//                    children: <Widget>[
//                      Container(
//                        child: Image.memory(_byteList),
//                        height: MediaQuery.of(context).size.height-appBar.preferredSize.height,
//                      ),
//                      Center(
//                        child: CircularPercentIndicator(
//                          radius: 100.0,
//                          lineWidth: 10.0,
//                          percent: _percentage,
//                          header: _text,
//                          center: _recordToggleButtonWidget(),
//                          backgroundColor: Colors.transparent,
//                          progressColor: Colors.red,
//                        ),
//                      ),
//                      Container(
//                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height-appBar.preferredSize.height- appBar.preferredSize.height),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            Column(
//                              children: <Widget>[
//                                _flashToggleButtonWidget(),
//                                _uploadGalleryWidget(),
//                              ],
//                            ),
//                            Column(
//                              children: <Widget>[
//                                _cameraTogglesRowWidget(),
//                                Container(
//                                  height: 50,
//                                  width: 50,
//                                  decoration: BoxDecoration(
//                                    color: Colors.redAccent,
//                                    shape: BoxShape.circle,
//                                  ),
//                                  child: Icon(Icons.stop, color: Colors.white,),
//                                )
//                              ],
//                            ),
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                Container(
//                  child: Stack(
//                    children: <Widget>[
//                      CameraPreview(_cameraController),
//
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Align(
//            child: Container(
////           decoration: BoxDecoration(color: Theme.of(context).primaryColor),
//              child: TabBar(
//                labelColor: Colors.white,
//                controller: _tabController,
//                tabs: [
//                  Tab(
//                    icon: const Icon(Icons.photo_camera, color: Colors.white,),
//                    text: 'Photo',
//                  ),
//                  Tab(
//                    icon: const Icon(Icons.videocam, color: Colors.white,),
//                    text: 'Video',
//                  ),
//                  Tab(
//                    icon: const Icon(Icons.music_note, color: Colors.white,),
//                    text: 'Audio',
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 40.0),
            child: _MediaPickerPageWidget(),
          ),
        )
    );
  }
}