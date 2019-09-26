import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:core';

class UploadSeriesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _UploadSeriesPageState();
}

class _UploadSeriesPageState extends State<UploadSeriesPage> with TickerProviderStateMixin{
  final TextEditingController _typeAheadController = TextEditingController();



  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Map<String, dynamic>> getSuggestions(pattern) {
    var _dataList = ["Cooking Show", "Motorcycle Diaries", "Flutter Series"];
    List<Map<String, dynamic>> suggestionList = List();
    _dataList.forEach((_data) {
      if(_data.contains(pattern)) {
        suggestionList.add({'name': _data});
      }
    });
    print(suggestionList.toString());
    return suggestionList;
  }

  Future _setMediaSource() async{
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(Icons.ondemand_video, size: 50.0, color: Colors.red,),
                          ),
                          Container(
                              child: Text("Record", style: TextStyle(fontSize: 10.0),)
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              SimpleDialogOption(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(Icons.video_library, size: 50.0, color: Colors.red,),
                          ),
                          Container(
                              child: Text("Gallery", style: TextStyle(fontSize: 10.0,),)
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          );
        }
    );
  }


  Widget uploadSeriesPageWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            height: 60.0,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: InputDecoration(
                  hintText: 'Series Name (Eg.TravelLogs)',
                  prefixText: "#",
                )
              ),
              suggestionsCallback: (pattern) async {
                return getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion['name']),
                );
              },
              onSuggestionSelected: (suggestion) {
                _typeAheadController.text = suggestion['name'];
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 60.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Video Title'
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 60.0,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: 'Description',
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              onPressed: (){
                _setMediaSource();
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
              padding: const EdgeInsets.all(8.0),
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(Icons.cloud_upload, color: Colors.white, size: 20,),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Upload Video", style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ],
              )
            ),
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
        padding: EdgeInsets.only(top: 10.0),
        child: uploadSeriesPageWidget(),
      ),
    );
  }
}