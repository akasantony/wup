import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:wup/utils/database/models/user.dart';
import 'package:wup/utils/constants/media.dart';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:intl/intl.dart';

class CropImagePage extends StatefulWidget {
  final File inputFile;


  const CropImagePage({Key key, @required this.inputFile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  File _croppedProfileImage;
  double _cropHeight = 200;
  double _cropWidth = 200;
  AppBar appBar;
  Matrix4 matrix;

  @override
  void initState() {
    appBar = AppBar();
    try{
    }catch(err)  {
      print("je");
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails scaleStartDetails) {
    print(scaleStartDetails);
  }

  Widget _cropImagePageBuilder() {
    return Container(
      child: Stack(
        children: <Widget>[
          MatrixGestureDetector(
            onMatrixUpdate: (m, tm, sm, rm) {
              setState(() {
                matrix = m;
              });
            },
            child: Transform(
              transform: matrix,
              child: Container(
                height: MediaQuery.of(context).size.height-appBar.preferredSize.height,
                child: Image.file(widget.inputFile),
              ),
            ),
          ),
          Container(
            height: _cropHeight,
            width: _cropWidth,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 2, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: _cropImagePageBuilder(),
    );
  }
}


