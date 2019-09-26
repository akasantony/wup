import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:countdown/countdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wup/pages/user/flips/media_editor.dart';
import 'package:wup/Utils/Media/camera.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:wup/utils/constants/media.dart';

class CreateFlipPage extends StatefulWidget {
  final List<CameraDescription> cameraDescription;

  const CreateFlipPage({Key key, @required this.cameraDescription,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateFlipPageState();
}

class _CreateFlipPageState extends State<CreateFlipPage> with SingleTickerProviderStateMixin{

  CameraController _cameraController;
  TabController _tabController;
  AppBar appBar;
  int _countDownValue = 15;
  Text _text = Text("Tap to record", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),);
  bool _hasStartedRecording = false;
  var sub;
  String _videoFilePath;
  String _videoAction = "record";
  bool _isMediaPhoto = true;

  CountDown _countDown = CountDown(Duration(seconds: 15), refresh: Duration(seconds: 1));

  List<CameraDescription> cameras;
  int selectedCameraIdx;

  @override
  void initState() {
    appBar = AppBar();
    _tabController = new TabController(length: 3, vsync: this);

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


    _cameraController = CameraController(cameraDescription, ResolutionPreset.medium);

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
    print("Video Action: $_videoAction");
    switch (_videoAction) {
      case 'record':
        sub = _countDown.stream.listen(null);
        setState(() {
          _videoAction = 'pause';
        });
        _startVideoRecording().then((onValue) {
          sub.onData((duration) {
            setState(() {
              _countDownValue = _countDownValue-1;
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
        setState(() {
          _videoAction = 'pause';
        });
        sub.resume();
        _resumedVideoRecording().then((onValue) {
          sub.onData((duration) {
            setState(() {
              _countDownValue = _countDownValue-1;
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
    selectedCameraIdx = selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
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
    print("Started Recording...");
    if(!_hasStartedRecording){
      return IconButton(icon: Icon(Icons.camera,color: Colors.white, size: 20,),
        onPressed: (){
          _hasStartedRecording = true;
          _videoRecordingController();
        },
      );
    }

    switch(_videoAction) {
      case 'resume':
        return IconButton(icon: Icon(Icons.camera,color: Colors.white, size: 20,),
          onPressed: (){
            _videoRecordingController();
          },
        );
        break;

      case 'pause':
        return IconButton(icon: Icon(Icons.pause,color: Colors.white, size: 20,),
          onPressed: (){
            _videoRecordingController();
          },
        );
        break;
    }

  }

  void setImagePreview(bytesImage) {
  }

  Widget _uploadGalleryWidget(){
    return SizedBox();
  }

  void _takePicture() async{
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/tmp/image_flips';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String _imageFilePath = '$videoDirectory/$currentTime.jpg';
    await _cameraController.takePicture(_imageFilePath);
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => MediaEditorPage(mediaFilePath: _imageFilePath ,mediaType: MediaType.image)
      ),
    );
  }


  Widget _mediaWidget() {
    if(_isMediaPhoto) {
      return Container(
        child: Stack(
          children: <Widget>[
            CameraPreview(_cameraController),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text("Photo", style: TextStyle(color: Colors.white),),
                    Switch(
                      value: _isMediaPhoto,
                      onChanged: (value) {
                        setState(() {
                          _isMediaPhoto = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.redAccent,
                    ),
                  ],
                ),
              )
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: Icon(Icons.tune, color: Colors.white,),
                  onPressed: (){},
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: _flashToggleButtonWidget(),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: _cameraTogglesRowWidget()
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async{
                  _takePicture();
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2.0),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.tune),
                onPressed: _uploadGalleryWidget,
              ),
            ),
          ],
        ),
      );
    }
    else {
      return Container(
        child: Stack(
          children: <Widget>[
            CameraPreview(_cameraController),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text("Video", style: TextStyle(color: Colors.white),),
                      Switch(
                        value: _isMediaPhoto,
                        onChanged: (value) {
                          setState(() {
                            _isMediaPhoto = value;
                          });
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: Colors.redAccent,
                      ),
                    ],
                  ),
                )
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.tune, color: Colors.white,),
                onPressed: (){},
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: _flashToggleButtonWidget(),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: _cameraTogglesRowWidget()
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(_countDownValue.toString(), style: TextStyle(color: Colors.white),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2.0),
                      shape: BoxShape.circle,
                    ),
                    child: _recordToggleButtonWidget(),
                  ),
                ],
              )
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.tune),
                onPressed: _uploadGalleryWidget,
              ),
            ),
          ],
        ),
      );
    }
  }


  Widget _createFlipPageWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: _mediaWidget()
    );
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          padding: const EdgeInsets.only(top: 30),
          child: _createFlipPageWidget(),
        ),
    );
  }
}