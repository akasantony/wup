import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wup/utils/constants/flips.dart';
import 'package:wup/utils/constants/media.dart';
import 'dart:core';

class MetaDialogue extends StatefulWidget {

  final Function onPost;
  final MediaType mediaType;

  MetaDialogue({Key key, this.onPost, this.mediaType}) : super(key: key);

  @override
  _MetaDialogueState createState() => new _MetaDialogueState();
}

class _MetaDialogueState extends State<MetaDialogue>{
  VisibilityStatus _visibilityStatus = VisibilityStatus.public;
  TextEditingController _descriptionFieldController;

  @override
  void initState() {
    _descriptionFieldController = TextEditingController();
    super.initState();
  }


  List<Map<String, String>> _showHashTagSuggestions(String hashtags) {
    var _dataList = ["#MakeMyApp", "#ItsMyLife", "#Nobody"];
    List<Map<String, String>> suggestionList = List();
    _dataList.forEach((_data) {
      if(_data.contains(hashtags)) {
        suggestionList.add({'data': _data}.cast<String, String>());
      }
    });
    print(suggestionList.toString());
    return suggestionList.cast<Map<String, String>>();
  }

  List<Map<String, String>> _showUsernameSuggestions(String usernamePattern) {
    var _dataList = ["@akasantony", "@mathai", "@govinda"];
    List<Map<String, String>> suggestionList = List();
    _dataList.forEach((String _data) {
      if(_data.contains(usernamePattern)) {
        suggestionList.add({'data': _data}.cast<String, String>());
      }
    });
    print(suggestionList.toString());
    return suggestionList.cast<Map<String, String>>();
  }

  List<Map<String, String>> _suggestionBoxController(String text) {
    List<String> _words = text.split((" "));
    if(_words[_words.length-1].startsWith("#")) {
      return _showHashTagSuggestions(_words[_words.length-1]);
    }
    else if (_words[_words.length-1].startsWith("@")){
      return _showUsernameSuggestions(_words[_words.length-1]);
    }
  }

  @override
  Widget build(BuildContext context){
    return SimpleDialog(
      title: Text("Post"),
      children: <Widget>[
        SimpleDialogOption(
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: _descriptionFieldController,
                decoration: InputDecoration(
                  hintText: 'Description',
                )
            ),
            suggestionsCallback: (pattern) async {
              return _suggestionBoxController(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("https://media.vanityfair.com/photos/5c0ef15ae2641b48c86501e9/master/pass/Megan-Fox-MeToo-Story%20(1).jpg"),
                ),
                title: Text(suggestion['data']),
              );
            },

            onSuggestionSelected: (suggestion) {
              _descriptionFieldController.text = suggestion['data'];
            },
          ),
        ),
        SimpleDialogOption(
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.grey
            ),
            child: ExpandablePanel(
              header: Text("Visibility", style: TextStyle(fontWeight: FontWeight.bold),),
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              hasIcon: true,
              expanded: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Public"),
                      Radio(
                        value: VisibilityStatus.public,
                        groupValue: _visibilityStatus,
                        onChanged: (VisibilityStatus status) {
                          setState(() {
                            _visibilityStatus = status;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: 30,),
                  Column(
                    children: <Widget>[
                      Text("Followers"),
                      Radio(
                        value: VisibilityStatus.followers,
                        groupValue: _visibilityStatus,
                        onChanged: (VisibilityStatus status) {
                          print(_visibilityStatus);
                          setState(() {
                            _visibilityStatus = status;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: 30,),
                  Column(
                    children: <Widget>[
                      Text("Mutual"),
                      Radio(
                        value: VisibilityStatus.mutual,
                        groupValue: _visibilityStatus,
                        onChanged: (VisibilityStatus status) {
                          print(_visibilityStatus);
                          setState(() {
                            _visibilityStatus = status;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          ),
        ),
        SimpleDialogOption(
          child: RaisedButton(
              color: Colors.blue,
              child: Text("Post", style: TextStyle(color: Colors.white),),
              onPressed: (){
                var postMeta = {
                  "description": _descriptionFieldController.text,
                  "visibility": _visibilityStatus,
                  'mediatype': widget.mediaType
                };
                widget.onPost(postMeta);
                Navigator.pop(context);
              },
          ),
        ),
      ],
    );
  }
}